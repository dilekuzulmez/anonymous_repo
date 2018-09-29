require 'rails_helper'

RSpec.describe LoyaltyPointRulesController, type: :controller do
  let(:rule_attributes) { attributes_for(:loyalty_point_rule) }
  let(:rule) { create(:loyalty_point_rule) }
  let!(:rules) { create_list(:loyalty_point_rule, 3) }
  let(:expect_302) { expect(response.status).to eq(302) }
  let(:expect_200) { expect(response.status).to eq(200) }
  let(:expect_404) { expect(response.status).to eq(404) }

  describe 'get action rules without signed in' do
    it 'get #index and response 302' do
      get :index
      expect_302
    end

    it 'get #edit and response 302' do
      get :edit, params: { id: rule.id }
      expect_302
    end

    it 'get #show and response 302' do
      get :show, params: { id: rule.id }
      expect_302
    end

    it 'patch #update and response 302' do
      patch :update, params: { id: rule.id, loyalty_point_rule: { name: 'Changed!' } }
      expect_302
    end
  end

  describe 'admin signed in' do
    let!(:admin) { create(:admin) }

    before do
      sign_in admin
    end

    describe 'get #index rules' do
      it 'return 200 and 3 rules' do
        get :index
        expect_200
        expect(rules.count).to eq(3)
      end
    end

    describe 'get #show rules' do
      let(:action) { get :show, params: { id: rule.id } }

      it 'return 200 and rules info' do
        action
        expect(response.body).to include(rule.name)
        expect_200
      end
    end

    describe 'get #edit rules' do
      let(:action) { get :edit, params: { id: rule.id } }

      it 'return 200 and rules info' do
        action
        expect_200
        expect(response.body).to include(rule.name, rule.point.to_s)
      end
    end

    describe 'patch #update rules' do
      let(:action) { patch :update, params: { id: rule.id, loyalty_point_rule: { name: 'changed' } } }

      context 'with valid attributes' do
        it 'update a record' do
          action
          expect(response).to redirect_to loyalty_point_rules_path
          rule.reload
          expect(rule.name).to eq('changed')
        end
      end

      context 'with invalid attributes' do
        let(:action) { patch :update, params: { id: rule.id, loyalty_point_rule: { name: '' } } }

        it 'reject to be updated' do
          action
          rule.reload
          expect(rule.name).to eq('update profile')
        end
      end
    end
  end
end
