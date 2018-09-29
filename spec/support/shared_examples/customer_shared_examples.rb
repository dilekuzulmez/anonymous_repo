shared_context 'initialize auth' do
  let(:customer) { create(:customer) }
  let(:headers) { { 'Token' => customer.access_token } }

  before do
    request.headers.merge! headers
    request.accept = 'application/json'
  end
end

shared_context 'employee initialize auth' do
  let(:admin) { create(:admin, employee_token: Devise.friendly_token, token_expire: Time.now + 2.days) }
  let(:headers) { { 'token' => admin.employee_token } }

  before do
    request.headers.merge! headers
    request.accept = 'application/json'
  end
end

shared_examples 'a successful request' do
  it 'returns an OK (200) status code' do
    expect(response.status).to eq 200
  end
end

shared_examples 'an unsuccessful request' do
  it 'returns an FAILED (400) status code' do
    expect(response.status).to eq 400
  end
end

shared_examples 'an internal system error' do
  it 'returns an ERROR (500) status code' do
    expect(response.status).to eq 500
  end
end
