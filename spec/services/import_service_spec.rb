require 'rails_helper'

describe ImportService do
  subject(:service) { described_class.new }

  let(:file_path) { File.open("#{Rails.root}/spec/fixtures/sample_matches.csv") }
  let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path) }
  let(:bucket_key) { 'sample_matches.csv' }
  let(:upload_file) { Object.new }
  let(:triggered_user) { create(:admin) }

  let(:execution) { service.execute(uploaded_file, triggered_user) }

  before do
    allow(S3_BUCKET).to receive(:object).and_return(upload_file)
    allow(upload_file).to receive(:upload_file).and_return(true)
    allow(upload_file).to receive(:key).and_return(bucket_key)
  end

  describe '#execute' do
    context 'file upload success' do
      it 'enqueues ImportMatchJob' do
        expect { execution }.to have_enqueued_job.on_queue('import').with(bucket_key, triggered_user)
        expect(execution).to eq('Records are queued to be import')
      end
    end

    context 'invalid match' do
      let(:uploaded_file) { nil }

      it 'enqueues ImportMatchJob' do
        expect(execution).to eq('Please select template file to import')
      end
    end
  end
end
