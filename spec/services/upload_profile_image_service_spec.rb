require 'rails_helper'

describe UploadProfileImageService do
  subject(:service) { described_class.new }

  let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path) }
  let(:upload_file) { Object.new }
  let(:identifier) { create(:customer) }
  let(:url) { 'https:google.com' }

  let(:execution) { service.execute(uploaded_file, identifier) }

  before do
    allow(S3_BUCKET).to receive(:object).and_return(upload_file)
    allow(upload_file).to receive(:upload_file).and_return(true)
    allow(upload_file).to receive(:public_url).and_return(url)
  end

  describe '#execute' do
    context 'valid param' do
      let(:file_path) { File.open("#{Rails.root}/spec/fixtures/sample_profile_image.jpg") }

      it 'uploads image to AWS S3' do
        expect(execution).to eq(url)
      end
    end

    context 'valid param' do
      let(:uploaded_file) { nil }

      it 'returns false' do
        expect(execution).to eq(nil)
      end
    end
  end
end
