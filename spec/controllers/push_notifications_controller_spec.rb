require 'rails_helper'

RSpec.describe PushNotificationsController, type: :controller do
  let!(:customers) { create_list(:customer, 3) }
  let(:noti_attributes) { attributes_for(:push_notification) }
  let(:noti) { create(:push_notification) }
  let(:notis) { create_list(:push_notification, 3) }
  let(:expect_302) { expect(response.status).to eq(302) }
  let(:expect_200) { expect(response.status).to eq(200) }
  let(:expect_404) { expect(response.status).to eq(404) }

  describe 'get action noti without signed in' do
    it 'get #index and response 302' do
      get :index
      expect_302
    end

    it 'get #new and response 302' do
      get :new
      expect_302
    end

    it 'post #create and response 302' do
      post :create, params: { push_notification: noti_attributes }
      expect_302
    end

    it 'get #edit and response 302' do
      get :edit, params: { id: noti.id }
      expect_302
    end

    it 'delete #destroy and response 302' do
      delete :destroy, params: { id: noti.id }
      expect_302
    end

    it 'patch #update and response 302' do
      patch :update, params: { id: noti.id, noti: { name: 'Changed!' } }
      expect_302
    end
  end

  describe 'admin signed in' do
    let!(:admin) { create :admin }

    before { sign_in admin }

    describe 'get #index noti' do
      it 'return 200 and 3 notis' do
        get :index
        expect_200
        expect(notis.count).to eq(3)
      end
    end

    describe 'get #new noti' do
      it 'return 200 and render new page' do
        get :new
        expect_200
        expect(response.body).to include('Create new push notification')
      end
    end

    describe 'get #edit noti' do
      it 'return 200 and edit page' do
        get :edit, params: { id: noti.id }
        expect_200
        expect(response.body).to include(noti.title, 'Edit push notification')
      end
    end

    describe 'post #create noti' do
      let(:action) { post :create, params: { push_notification: noti_attributes } }

      it 'return 200 and create 1 record' do
        expect_200
        expect { action }.to change(PushNotification, :count).from(0).to(1)
      end

      context 'without title is OK' do
        let(:noti_attributes) { { title: '', body: 'hello' } }

        it 'accept to save into DB' do
          expect(PushNotification.count).to eq(0)
          action
          expect(PushNotification.count).to eq(1)
        end
      end
    end

    describe 'patch #update noti' do
      let!(:noti) { create(:push_notification) }
      let(:action) { patch :update, params: { id: noti, push_notification: noti_attributes } }

      context 'with valid attr' do
        let!(:noti_attributes) { { title: 'Changed' } }

        it 'return 200 and update successfully' do
          action
          expect_302
          noti.reload
          expect(noti.title).to eq('Changed')
        end
      end

      context 'with blank attr' do
        let!(:noti_attributes) { { title: '' } }
        let!(:temp) { noti.title }

        it 'update a record' do
          action
          noti.reload
          expect(noti.title).to eq('')
        end
      end

      context 'with invalid attr' do
        let!(:noti_attributes) { { invalid: 'invalid' } }

        it 'not update a record' do
          action
          expect(response.status).to eq(400)
        end
      end
    end

    describe 'delete #destroy noti' do
      let!(:noti) { create(:push_notification) }
      let(:action) { delete :destroy, params: { id: noti.id } }

      it 'return 302 and delete record' do
        expect { action }.to change(PushNotification, :count).from(1).to(0)
        expect_302
      end
    end

    describe 'post #all_customers' do
      it 'not push bcs invalid token & save to db' do
        post :all_customers, params: { id: noti.id }
        expect_302
        expect(NotiHistory.where(status: true).count).to eq(customers.count)
      end
    end

    describe 'post #single_push' do
      it 'not push bcs invalid token & save to db' do
        Customer.update_all(push_token: 'blank')
        post :single_push, params: { id: noti.id, customer_id: Customer.first.id }, format: 'js'
        expect(NotiHistory.where(status: false).count).to eq(1)
        expect(response.body).to include('failed')
      end
    end
  end
end
