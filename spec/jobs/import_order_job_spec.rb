# require 'rails_helper'
# RSpec.describe ImportOrderJob, type: :job do
#   let(:triggered_user) { create(:admin) }
#   let(:csv_data) { File.read(file_path) }
#   let(:perform) { ImportOrderJob.perform_now(bucket_key, triggered_user) }
#   let(:bucket_key) { 'abc' }
#   let(:s3_mock) { Object.new }
#   let(:s3_body) { Object.new }
#   let(:s3_file) { Object.new }

#   before do
#     allow(S3_BUCKET).to receive(:object).with(bucket_key).and_return(s3_mock)
#     allow(s3_mock).to receive(:get).and_return(s3_body)
#     allow(s3_body).to receive(:body).and_return(s3_file)
#     allow(s3_file).to receive(:read).and_return(csv_data)
#   end

#   context 'valid csv data' do
#     let(:file_path) { "#{Rails.root}/spec/fixtures/sample_orders.csv" }

#     it 'creates 2 new matches' do
#       expect { perform }.to change(Order, :count).by(8)
#     end

#     it 'creates correct data' do
#       perform
#       expect(Order.find_by(order_code: 'BFSGZX').order_details.first.match.start_time)
#         .to eq(DateTime.parse('9-9-2017 19:24:00 +0700'))
#       expect(Order.find_by(order_code: '5VHZT1').order_details.first.match.start_time)
#         .to eq(DateTime.parse('9-9-2017 19:24:00 +0700'))
#     end

#     it 'creates success notification' do
#       expect { perform }.to change(Notification, :count).by(1)
#       expect(Notification.last.kind).to be_success
#       expect(Notification.last.admin).to eq(triggered_user)
#     end
#   end

#   context 'invalid data' do
#     let(:file_path) { "#{Rails.root}/spec/fixtures/invalid_order_data.csv" }

#     it 'doesnt create any record' do
#       expect { perform }.not_to change(Match, :count)
#     end

#     it 'creates notification of kind danger' do
#       expect { perform }.to change(Notification, :count).by(1)
#       expect(Notification.last.kind).to be_danger
#       expect(Notification.last.admin).to eq(triggered_user)
#     end
#   end
# end
