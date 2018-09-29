require 'rails_helper'

RSpec.describe SurveysController, type: :controller do
  let(:survey_attributes) { attributes_for(:survey) }
  let(:survey) { create(:survey) }
  let(:surveys) { create_list(:survey, 3) }
  let(:expect_302) { expect(response.status).to eq(302) }
  let(:expect_200) { expect(response.status).to eq(200) }
  let(:expect_404) { expect(response.status).to eq(404) }

  describe 'get action survey without signed in' do
    it 'get #index and response 302' do
      get :index
      expect_302
    end

    it 'get #new and response 302' do
      get :new
      expect_302
    end

    it 'post #create and response 302' do
      post :create, params: { survey: survey_attributes }
      expect_302
    end

    it 'get #edit and response 302' do
      get :edit, params: { id: survey.id }
      expect_302
    end

    it 'get #show and response 302' do
      get :show, params: { id: survey.id }
      expect_302
    end

    it 'delete #destroy and response 302' do
      delete :destroy, params: { id: survey.id }
      expect_302
    end

    it 'patch #update and response 302' do
      patch :update, params: { id: survey.id, survey: { name: 'Changed!' } }
      expect_302
    end
  end

  describe 'admin signed in' do
    let!(:admin) { create :admin }

    before { sign_in admin }

    describe 'get #index survey' do
      it 'return 200 and 3 surveys' do
        get :index
        expect_200
        expect(surveys.count).to eq(3)
      end
    end

    describe 'get #new survey' do
      it 'return 200 and render new page' do
        get :new
        expect_200
        expect(response.body).to include('Create new survey')
      end
    end

    describe 'get #show survey' do
      it 'return 200 and survey info' do
        get :show, params: { id: survey.id }
        expect_200
        expect(response.body).to include(survey.name)
      end

      it 'return 404 and record not found' do
        get :show, params: { id: survey.id + 1000 }
        expect_404
        expect(response.status).to eq(404)
      end
    end

    describe 'get #edit survey' do
      it 'return 200 and edit page' do
        get :edit, params: { id: survey.id }
        expect_200
        expect(response.body).to include(survey.name, 'Edit Survey')
      end
    end

    describe 'post #create survey' do
      let(:action) { post :create, params: { survey: survey_attributes } }

      context 'create a record that does not exist' do
        it 'return 200 and create 1 record' do
          expect_200
          expect { action }.to change(Survey, :count).from(0).to(1)
        end
      end

      context 'create the same record' do
        let(:survey_attributes) { { name: 'Hello', link: 'link.com' } }

        it 'reject to save into DB' do
          action
          expect(action).to redirect_to surveys_path
          expect(Survey.count).to eq(1)
          action
          expect(Survey.count).to eq(1)
        end
      end

      context 'without name or link' do
        let(:survey_attributes) { { name: '', link: 'link.com' } }

        it 'reject to save into DB' do
          expect(Survey.count).to eq(0)
          action
          expect(Survey.count).to eq(0)
        end
      end
    end

    describe 'patch #update survey' do
      let!(:survey) { create(:survey) }
      let(:action) { patch :update, params: { id: survey, survey: survey_attributes } }

      context 'with valid attr' do
        let!(:survey_attributes) { { name: 'Changed' } }

        it 'return 200 and update successfully' do
          action
          expect_302
          survey.reload
          expect(survey.name).to eq('Changed')
        end
      end

      context 'with blank attr' do
        let!(:survey_attributes) { { name: '' } }
        let!(:temp) { survey.name }

        it 'not update a record' do
          action
          survey.reload
          expect(survey.name).to eq(temp)
        end
      end

      context 'with invalid attr' do
        let!(:survey_attributes) { { invalid: 'invalid' } }

        it 'not update a record' do
          action
          expect(response.status).to eq(400)
        end
      end
    end

    describe 'delete #destroy survey' do
      let!(:survey) { create(:survey) }
      let(:action) { delete :destroy, params: { id: survey.id } }

      it 'return 302 and delete record' do
        expect { action }.to change(Survey, :count).from(1).to(0)
        expect_302
      end
    end
  end
end
