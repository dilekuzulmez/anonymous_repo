require 'rails_helper'

describe FacebookService do
  subject(:service) { described_class.new(provider, auth_code) }

  let(:auth_code) { 'abc' }
  let(:access_token) { 'access_token' }
  let(:mock_user_info) do
    {
      'id' => rand(100_000..999_999_999),
      'phone' => {
        number: Faker::PhoneNumber.phone_number
      }
    }
  end

  describe '#execute' do
    describe 'via account_kit' do
      let(:provider) { 'account_kit' }

      context 'valid token' do
        before do
          allow_any_instance_of(Facebook::AccountKit::TokenExchanger).to\
            receive(:fetch_access_token).and_return(access_token)
          allow_any_instance_of(Facebook::AccountKit::UserAccount).to\
            receive(:fetch_user_info).and_return(mock_user_info)
        end

        it 'returns hash with user info' do
          result = service.execute

          expect(result[:uid]).to eq(mock_user_info['id'])
          expect(result[:provider]).to eq('account_kit')
        end
      end

      context 'invalid token' do
        it 'raises exception' do
          expect { service.execute }.to raise_error(Facebook::AccountKit::InvalidRequest)
        end
      end
    end

    describe 'via facebook' do
      let(:provider) { 'facebook' }

      context 'valid token' do
        before do
          allow_any_instance_of(Koala::Facebook::API).to\
            receive(:get_object).and_return(mock_user_info)
        end

        it 'returns hash with user info' do
          result = service.execute

          expect(result[:uid]).to eq(mock_user_info['id'])
          expect(result[:provider]).to eq('facebook')
        end
      end

      context 'invalid token' do
        it 'raises exception' do
          expect { service.execute }.to raise_error(Koala::Facebook::AuthenticationError)
        end
      end
    end
  end
end
