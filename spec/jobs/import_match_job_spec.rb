require 'rails_helper'

shared_context 'import_match' do
  before do
    s = Stadium.create(name: 'Nhà thi đấu trường quốc tế CIS')
    Team.create(name: 'Saigon Heat', home_stadium: s)
    Team.create(name: 'Hanoi Buffaloes')

    Timecop.freeze(Time.local(2017, 8, 1))
  end

  after { Timecop.return }
end

RSpec.describe ImportMatchJob, type: :job do
  include_context 'import_match'

  let(:triggered_user) { create(:admin) }
  let(:csv_data) { File.read(file_path) }
  let(:perform) { ImportMatchJob.perform_now(bucket_key, triggered_user) }
  let(:bucket_key) { 'abc' }
  let(:s3_mock) { Object.new }
  let(:s3_body) { Object.new }
  let(:s3_file) { Object.new }

  before do
    allow(S3_BUCKET).to receive(:object).with(bucket_key).and_return(s3_mock)
    allow(s3_mock).to receive(:get).and_return(s3_body)
    allow(s3_body).to receive(:body).and_return(s3_file)
    allow(s3_file).to receive(:read).and_return(csv_data)
  end

  context 'valid csv data' do
    let(:file_path) { "#{Rails.root}/spec/fixtures/sample_matches.csv" }

    it 'creates 2 new matches' do
      expect { perform }.to change(Match, :count).by(2)
    end

    it 'creates correct data' do
      perform

      expect(Match.first.start_time).to eq(DateTime.parse('19-08-2017 06:00PM'))
      expect(Match.last.start_time).to eq(DateTime.parse('19-11-2017 06:00PM'))
    end

    it 'creates success notification' do
      expect { perform }.to change(Notification, :count).by(1)
      expect(Notification.last.kind).to be_success
      expect(Notification.last.admin).to eq(triggered_user)
    end
  end

  context 'invalid data' do
    let(:file_path) { "#{Rails.root}/spec/fixtures/invalid_match_data.csv" }

    it 'doesnt create any record' do
      expect { perform }.not_to change(Match, :count)
    end

    it 'creates notification of kind danger' do
      expect { perform }.to change(Notification, :count).by(1)
      expect(Notification.last.kind).to be_danger
      expect(Notification.last.admin).to eq(triggered_user)
    end
  end
end
