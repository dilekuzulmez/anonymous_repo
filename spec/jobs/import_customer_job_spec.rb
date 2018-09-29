require 'rails_helper'

RSpec.describe ImportCustomerJob, type: :job do
  let(:triggered_user) { create(:admin) }
  let(:csv_data) { File.read(file_path) }
  let(:bucket_key) { 'abc' }
  let(:perform) { ImportCustomerJob.perform_now(bucket_key, triggered_user) }
  let(:s3_mock) { Object.new }
  let(:s3_body) { Object.new }
  let(:s3_file) { Object.new }
  let(:test_customer) { Customer.last }
  let(:test_notification) { Notification.last }

  before do
    allow(S3_BUCKET).to receive(:object).with(bucket_key).and_return(s3_mock)
    allow(s3_mock).to receive(:get).and_return(s3_body)
    allow(s3_body).to receive(:body).and_return(s3_file)
    allow(s3_file).to receive(:read).and_return(csv_data)
  end

  context 'valid template' do
    let(:file_path) { "#{Rails.root}/spec/fixtures/customers_sample.csv" }
    let(:expected_data) do
      {
        email: 'linh.lan@xle.vn',
        first_name: 'Linh',
        last_name: 'Lan',
        gender: 'female',
        birthday: '1996-01-12',
        phone_number: '937850114'
      }
    end

    it 'creates 1 new customer' do
      expect { perform }.to change(Customer, :count).by(3)
    end

    it 'creates correct data' do
      perform

      expected_data.each_pair do |key, val|
        expect(test_customer.public_send(key).to_s).to eq(val)
      end

      expect(test_customer.address).to match('district' => 'Vung Tau', 'city' => 'BR-VT')
    end

    it 'creates success notification' do
      expect { perform }.to change(Notification, :count).by(1)
      expect(test_notification.kind).to be_success
      expect(test_notification.admin).to eq(triggered_user)
    end
  end

  context 'invalid template' do
    let(:file_path) { "#{Rails.root}/spec/fixtures/invalid_customers_sample.csv" }

    it 'does not create any record' do
      expect { perform }.not_to change(Customer, :count)
    end

    it 'creates notification in danger kind' do
      expect { perform }.to change(Notification, :count).by(1)
      expect(test_notification.kind).to be_danger
      expect(test_notification.admin).to eq(triggered_user)
    end
  end
end
