require 'rails_helper'

RSpec.describe VersionsController, type: :controller do
  let!(:admin) { create(:admin) }

  before do
    sign_in admin
  end
  describe 'get #index versions' do
    let!(:versions) { create_list(:version, 1) }

    it 'return 200 and just create 1 version' do
      get :index
      expect(response.status).to eq(200)
      expect(versions.count).to eq(1)
    end
  end

  describe 'post #create version' do
    let(:version_attributes) { attributes_for(:version) }
    let(:action) { post :create, params: { version: version_attributes } }

    context 'with no version record yet' do
      it 'create a new version' do
        expect(response.status).to eq(200)
        expect { action }.to change(Version, :count).by(1)
        expect(response).to redirect_to(versions_path)
      end
    end
    context 'version record exists' do
      let!(:version) { create(:version) }

      it 'reject to create new record' do
        expect(response.status).to eq(200)
        expect { action }.to change(Version, :count).by(0)
        expect(response.body).to include('OS existed.')
      end
    end
  end

  describe 'get #new version' do
    context 'with no version record yet' do
      it 'return success render' do
        get :new
        expect(response.status).to eq(200)
      end
    end

    context 'with record exists' do
      let!(:ios) { create(:version, os: 'IOS') }
      let!(:android) { create(:version, os: 'ANDROID') }

      it 'redirect to index path and set flash' do
        get :new
        expect(response).to redirect_to(versions_path)
        expect(controller).to set_flash[:notice]
      end
    end
  end

  describe 'get #edit version' do
    let!(:version) { create(:version) }

    it 'return success render edit' do
      get :edit, params: { id: version.id }
      expect(response).to be_success
    end
    it 'redirect to index path if record not found' do
      get :edit, params: { id: version.id + 1 }
      expect(response).to redirect_to(versions_path)
    end
  end

  describe 'patch #update version' do
    let!(:version) { create(:version) }
    let!(:version_android) { create(:version, os: 'ANDROID') }
    let(:action) { patch :update, params: { id: version.id, version: new_attributes } }

    context 'valid params' do
      let(:new_attributes) { { number: '3.1.3', description: 'testing' } }

      it 'return update successfully and redirect to index' do
        action
        expect(controller).to set_flash[:notice]
        expect(response).to redirect_to(versions_path)
        version.reload
        expect(version.number).to eq('3.1.3')
      end
    end

    context 'with existed OS' do
      let(:new_attributes) { { os: 'ANDROID' } }

      it 'render new and set message' do
        action
        expect(response.status).to eq(200)
        expect(response.body).to include('OS existed.')
      end
    end

    context 'invalid params' do
      let(:new_attributes) { { number: '' } }

      it 'render edit template' do
        action
        expect(response.status).to eq(200)
        expect(version.number).to eq('1.5.3')
        version.reload
        expect(version.number).to eq('1.5.3')
      end
    end

    context 'nonsense params' do
      let(:new_attributes) { { invalid: 'invalid' } }

      it 'raise the unpermitted params errors' do
        action
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'delete #destroy version' do
    let!(:version) { create(:version) }
    let(:action) { delete :destroy, params: { id: version.id } }

    it 'remove a version record' do
      expect(Version.count).to eq(1)
      action
      expect(Version.count).to eq(0)
      expect(response).to redirect_to(versions_path)
    end
  end
end
