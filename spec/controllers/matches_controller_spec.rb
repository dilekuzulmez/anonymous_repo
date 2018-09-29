require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  let(:admin) { create(:admin) }

  let(:excluded_attrs) { %w[created_at updated_at id] }

  let(:valid_attributes) do
    build(:match).attributes.except!(*excluded_attrs)
  end

  let(:invalid_attributes) do
    build(:match, start_time: nil).attributes.except!(*excluded_attrs)
  end

  before do
    sign_in admin
    Timecop.freeze(Time.local(2017, 8, 12, 16))
  end

  after { Timecop.return }

  describe 'GET #index' do
    it 'returns a success response' do
      Match.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      match = Match.create! valid_attributes
      get :show, params: { id: match.to_param }
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
    it 'returns a success response' do
      match = Match.create! valid_attributes
      get :edit, params: { id: match.to_param }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Match' do
        expect do
          post :create, params: { match: valid_attributes }
        end.to change(Match, :count).by(1)
      end

      it 'redirects to the seat manager' do
        post :create, params: { match: valid_attributes }
        expect(response).to redirect_to matches_path
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { match: invalid_attributes }
        expect(response).to be_success
        expect(Match.count).to eq(0)
      end
    end

    context 'with invalid params one match selected' do
      let(:one_match_params) do
        exclude = %w[created_at updated_at id home_team_id]
        build(:match).attributes.except!(*exclude)
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { match: one_match_params }
        expect(response).to be_success
        expect(Match.count).to eq(0)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { round: 'final' }
      end

      it 'updates the requested match' do
        match = Match.create! valid_attributes
        put :update, params: { id: match.to_param, match: new_attributes }
        match.reload
        expect(match.round).to eq('final')
      end

      it 'redirects to the match' do
        match = Match.create! valid_attributes
        put :update, params: { id: match.to_param, match: valid_attributes }
        expect(response).to redirect_to(matches_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        match = Match.create! valid_attributes
        put :update, params: { id: match.to_param, match: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested match' do
      match = Match.create! valid_attributes
      expect do
        delete :destroy, params: { id: match.to_param }
      end.to change(Match, :count).by(-1)
    end

    it 'redirects to the matches list' do
      match = Match.create! valid_attributes
      delete :destroy, params: { id: match.to_param }
      expect(response).to redirect_to(matches_url)
    end
  end

  describe 'GET #import' do
    it 'returns http success' do
      get :import
      expect(response).to be_success
    end
  end

  describe 'POST #bulk_create' do
    let(:file_path) { File.open("#{Rails.root}/spec/fixtures/sample_matches.csv") }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path) }
    let(:action) { post :bulk_create, params: { file: uploaded_file } }
    let(:object) { Object.new }
    let(:message) { 'Success' }

    before do
      allow(ImportService).to receive(:new).and_return(object)
      allow(object).to receive(:execute).and_return(message)
    end

    it 'redirects to index path' do
      action
      expect(response).to redirect_to(import_matches_path)
    end
  end
end
