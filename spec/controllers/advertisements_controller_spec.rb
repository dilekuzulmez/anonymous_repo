require 'rails_helper'

RSpec.describe AdvertisementsController, type: :controller do
  def convert_attributes(attributes)
    new_attributes = attributes.dup
    duration = new_attributes.delete(:duration)

    if duration
      new_attributes[:duration_start] = duration.first
      new_attributes[:duration_end] = duration.last
    end

    new_attributes
  end

  let!(:ads) { create_list(:advertisement, 3) }
  let!(:promotion) { create(:promotion) }
  let(:ad) { create(:advertisement, promotion_id: promotion.id) }
  let(:ad_attributes) { attributes_for(:advertisement) }
  let(:expect_302) { expect(response.status).to eq(302) }
  let(:expect_200) { expect(response.status).to eq(200) }
  let(:expect_404) { expect(response.status).to eq(404) }

  describe 'get action ads without signed in' do
    it 'get #index and response 302' do
      get :index
      expect_302
    end

    it 'get #new and response 302' do
      get :new
      expect_302
    end

    it 'get #edit and response 302' do
      get :edit, params: { id: ad.id }
      expect_302
    end

    it 'get #show and response 302' do
      get :show, params: { id: ad.id }
      expect_302
    end

    it 'post #create and response 302' do
      post :create, params: { advertisement: ad_attributes }
      expect_302
    end

    it 'patch #update and response 302' do
      patch :update, params: { id: ad.id, advertisement: { title: 'Changed!' } }
      expect_302
    end

    it 'delete #destroy and response 302' do
      delete :destroy, params: { id: ad.id }
      expect_302
    end
  end

  describe 'admin signed in' do
    let!(:admin) { create(:admin) }

    before do
      sign_in admin
    end

    describe 'get #index ads' do
      it 'return 200 and 3 ads' do
        get :index
        expect_200
        expect(ads.count).to eq(3)
      end
    end

    describe 'get #new ads' do
      let(:action) { get :new, params: {} }

      it 'return 200 and render new' do
        action
        expect(response.body).to include('Create new advertisement')
        expect_200
      end
    end

    describe 'get #show ads' do
      let(:action) { get :show, params: { id: ad.id } }

      it 'return 200 and ads info' do
        action
        expect(response.body).to include(ad.title)
        expect(ad.title).to eq('Hello')
        expect_200
      end

      it 'with invalid id and return 404 and not found mess' do
        get :show, params: { id: ad.id + 1 }
        expect(response.body).to include('Record Not Found')
        expect_404
      end
    end

    describe 'get #edit ads' do
      let(:action) { get :edit, params: { id: ad.id } }

      it 'return 200 and ads info' do
        action
        expect_200
        expect(response.body).to include(ad.title, ad.promotion.code)
      end

      it 'with invalid id and return 404 and not found mess' do
        get :edit, params: { id: ad.id + 1 }
        expect_404
        expect(response.body).to include('Record Not Found')
      end
    end

    describe 'post #create ads' do
      let(:action) { post :create, params: { advertisement: convert_attributes(ad_attributes) } }

      context 'with valid attributes' do
        it 'increase 1 ad' do
          expect(Advertisement.count).to eq(3)
          expect { action }.to change(Advertisement, :count).by(1)
          expect(Advertisement.count).to eq(4)
        end
      end

      context 'with empty attributes' do
        let(:action) { post :create, params: { advertisement: convert_attributes(ad_attributes) } }
        let(:ad_attributes) { attributes_for(:advertisement, title: '') }

        it 'reject to save without title' do
          expect(Advertisement.count).to eq(3)
          expect { action }.to change(Advertisement, :count).by(0)
        end
      end
    end

    describe 'patch #update ads' do
      let(:action) { patch :update, params: { id: ad.id, advertisement: { title: 'changed', priority: true } } }

      context 'with valid attributes' do
        it 'update a record' do
          action
          expect(response).to redirect_to advertisements_path
          ad.reload
          expect(ad.title).to eq('changed')
          expect(Advertisement.sort_priority.first.title).to eq(ad.title)
        end
      end

      context 'with invalid attributes' do
        let(:action) { patch :update, params: { id: ad.id, advertisement: { title: '' } } }

        it 'reject to be updated' do
          action
          ad.reload
          expect(ad.title).to eq('Hello')
        end
      end
    end

    describe 'delete #destroy ads' do
      let(:action) { delete :destroy, params: { id: ads.first.id } }

      context 'with valid id' do
        it 'delete a record' do
          expect(Advertisement.count).to eq(3)
          action
          expect(Advertisement.count).to eq(2)
        end
      end

      context 'with invalid id' do
        let(:action) { delete :destroy, params: { id: ads.first.id + 10_000 } }

        it 'reject to be deleted a record' do
          expect(Advertisement.count).to eq(3)
          action
          expect(Advertisement.count).to eq(3)
        end
      end
    end
  end
end
