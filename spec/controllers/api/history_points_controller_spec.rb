require 'rails_helper'
# rubocop:disable ExampleLength

RSpec.describe Api::HistoryPointsController, type: :controller do
  let!(:loyal) { create(:loyalty_point_rule, code: 'SUR', active: true, point: 10) }
  let!(:survey) { create(:survey) }

  describe 'without signed in customer' do
    it 'post #create_survey' do
      post :create_survey, params: { survey_id: survey.id }
      expect(response.status).to eq(403)
    end

    it 'post #deduct_points' do
      post :deduct_points, params: { points: 10 }
      expect(response.status).to eq(400)
    end
  end

  describe 'signed in customer' do
    include_context 'initialize auth'

    context 'invalid params passed' do
      it 'return 200 and error_message' do
        post :create_survey, params: { survey_id: survey.id + 999 }
        expect(response.status).to eq(422)
        data = JSON.parse(response.body)
        expect(data).to include 'error_message'
      end
    end

    context 'valid params passed' do
      let(:action) { post :create_survey, params: { survey_id: survey.id } }

      it 'return 200 and success_message' do
        action
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)
        expect(data).to include 'success_message'
        expect(customer.point).to eq(0)
        customer.reload
        expect(customer.point).to eq(10)
        expect(customer.noti_histories.count).to eq(1)
      end
    end

    context 'record existed' do
      let(:action) { post :create_survey, params: { survey_id: survey.id } }
      let!(:history_point) { create(:history_point, customer: customer, survey: survey) }

      it 'return 200 and reject update points' do
        action
        expect(response.status).to eq(422)
        data = JSON.parse(response.body)
        expect(data).to include 'error_message'
        expect(customer.point).to eq(0)
        customer.reload
        expect(customer.point).to eq(0)
      end
    end

    describe 'post #deduct_points' do
      let(:action) { post :deduct_points, params: deduct_points_params }

      context 'valid params passed' do
        let!(:deduct_points_params) { { customer_id: customer.id, points: 100 } }

        it 'return 200 deduct 100 points' do
          customer.update(point: 1000)
          action
          expect(response.status).to eq(200)
          customer.reload
          expect(customer.point).to eq(900)
          expect(HistoryPoint.count).to eq(1)
          expect(customer.noti_histories.count).to eq(1)
        end
      end

      context 'invalid params passed' do
        let!(:deduct_points_params) { { points: rand(-100..0) } }

        it 'reject to purchase and return failed message' do
          customer.update(point: 1000)
          action
          expect(response.status).to eq(400)
          customer.reload
          expect(customer.point).to eq(1000)
          expect(HistoryPoint.count).to eq(0)
        end
      end
    end
  end
end
