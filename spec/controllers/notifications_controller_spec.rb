require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe 'GET #index' do
    before do
      create_list(:notification, 3, admin: admin)
    end

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'sets all unread notifications as read' do
      expect(admin.unread_notifications.length).to eq(3)
      get :index
      expect(admin.reload.unread_notifications).to be_empty
    end
  end
end
