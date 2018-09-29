require 'rails_helper'

describe StadiumsController, type: :controller do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
    allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:stadium) { create(:stadium) }

    it 'returns a success response' do
      get :show, params: { id: stadium.slug }
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    let(:stadium) { create(:stadium) }

    it 'returns a success response' do
      get :edit, params: { id: stadium.slug }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    let(:seatmap) { "#{Rails.root}/spec/fixtures/sample_seatmap.png" }
    let(:logo) { "#{Rails.root}/spec/fixtures/sample_seatmap.png" }
    # rubocop:disable LineLength
    let(:action) { post :create, params: { stadium: stadium_attributes, seatmap: seatmap, logo: logo } }

    context 'with valid params' do
      let(:stadium_attributes) { attributes_for(:stadium) }

      it 'creates a new Stadium' do
        expect { action }.to change(Stadium, :count).by(1)
      end

      it 'redirects to the created stadium' do
        action
        expect(response).to redirect_to(stadiums_path)
      end
    end

    context 'with invalid params' do
      let(:stadium_attributes) { attributes_for(:stadium, name: '') }

      it "returns a success response (i.e. to display the 'new' template)" do
        action
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    let!(:stadium) { create(:stadium) }
    let(:seatmap) { "#{Rails.root}/spec/fixtures/sample_seatmap_2.png" }
    let(:logo) { "#{Rails.root}/spec/fixtures/sample_seatmap_2.png" }
    let(:action) { put :update, params: { id: stadium.slug, stadium: stadium_attributes, seatmap: seatmap, logo: logo } }

    context 'with valid params' do
      let(:stadium_attributes) { { address: 'Updated address' } }

      it 'updates the requested stadium' do
        action
        stadium.reload
        expect(stadium.address).to eq('Updated address')
      end

      it 'redirects to the stadium' do
        action
        expect(response).to redirect_to(stadiums_path)
      end
    end

    context 'with invalid params' do
      let(:stadium_attributes) { { name: '' } }

      it "returns a success response (i.e. to display the 'edit' template)" do
        action
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:stadium) { create(:stadium) }
    let(:action) { delete :destroy, params: { id: stadium.slug } }

    it 'destroys the requested stadium' do
      expect { action }.to change(Stadium, :count).by(-1)
    end

    it 'redirects to the stadia list' do
      action
      expect(response).to redirect_to(stadiums_path)
    end
  end
end
