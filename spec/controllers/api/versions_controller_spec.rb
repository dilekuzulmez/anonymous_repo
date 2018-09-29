require 'rails_helper'

describe Api::VersionsController, type: :controller do
  include_context 'initialize auth'
  describe 'get #official versions' do
    context 'version existed' do
      let!(:version) { create(:version) }

      it 'return official version' do
        get :official, params: { os: 'IOS' }
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)
        expect(data['version']).to eq('1.5.3')
      end
    end

    context "version don't exist" do
      it 'return version 0 because have no params' do
        get :official
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)
        expect(data['version']).to eq(0)
      end
    end

    context 'invalid params passed' do
      it 'return 200 and 0' do
        get :official, params: { invalid: 'invalid' }
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)
        expect(data['version']).to eq(0)
      end
    end
  end
end
