require 'rails_helper'

describe ReceiveFileService do
  describe '#execute' do
    let(:service) { described_class.new }
    let(:result) { service.execute(uploaded_file) }
    let(:uploaded_file) do
      Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/sample_matches.csv"))
    end

    it 'returns string' do
      expect(result).to be_a(String)
    end

    it 'is the copy file of the uploaded one' do
      file = File.open(result)
      expect(file.size).to eq(uploaded_file.tempfile.size)
    end
  end
end
