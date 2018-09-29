require 'rails_helper'

describe LoginCustomerService do
  subject(:service) { described_class.new(provider) }

  let(:provider) { Object.new }
  let(:facebook_uid) { rand(100_000...999_999_999) }
  let(:expected_data) do
    {
      uid: facebook_uid,
      provider: 'account_kit',
      phone_number: Faker::PhoneNumber.phone_number
    }
  end

  before do
    allow(provider).to receive(:execute).and_return(expected_data)
  end

  describe '#execute' do
    context 'new customer' do
      it 'creates new customer record' do
        expect { service.execute }.to change(Customer, :count).by(1)
      end

      it 'creates new identity record' do
        expect { service.execute }.to change(Identity, :count).by(1)
      end

      it 'generates customer access token' do
        service.execute

        expect(service.customer.access_token).not_to be_blank
      end
    end

    context 'exsting customer' do
      let(:facebook_uid) { 123 }
      let!(:customer) { create(:customer) }
      let!(:identity) do
        create(
          :identity,
          uid: facebook_uid,
          provider: 'account_kit',
          customer_id: customer.id
        )
      end

      it 'doesnt create new customer record' do
        expect { service.execute }.not_to change(Customer, :count)
      end

      it 'changes access_token' do
        current_access_token = customer.access_token
        service.execute
        expect(service.customer.access_token).not_to eq(current_access_token)
      end
    end
  end
end
