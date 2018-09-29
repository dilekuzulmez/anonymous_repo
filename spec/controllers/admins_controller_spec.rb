require 'rails_helper'

describe AdminsController, type: :controller do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:params) { nil }
    let(:action) { post :create, params: params }

    context 'when params is valid' do
      let(:params) { { admin: { email: Faker::Internet.email } } }

      it 'redirects to index page' do
        action
        expect(response).to redirect_to(admins_path)
      end

      it 'creates new admin record' do
        expect { action }.to change(Admin, :count).by(1)
      end

      it 'also sets created_by_id to current_admin id' do
        action
        expect(Admin.last.created_by_id).to eq(admin.id)
      end
    end

    context 'when params is invalid' do
      let(:params) { { admin: { email: '' } } }

      it 'doesnt create new record' do
        expect { action }.not_to change(Admin, :count)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: admin.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    let(:updated_email) { Faker::Internet.email }
    let(:action) { put :update, params: { id: admin.id, admin: { email: updated_email } } }

    context 'valid email' do
      it 'redirects to admins_path' do
        action
        expect(response).to redirect_to(admins_path)
      end

      it 'updates email value of admin account' do
        action
        expect(admin.reload.email).to eq(updated_email)
      end
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: admin.id }
      expect(response).to have_http_status(:success)
    end
  end
end
