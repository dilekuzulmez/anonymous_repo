require 'rails_helper'

RSpec.describe ConversionRatesController, type: :controller do
  let!(:conversion) { create(:conversion_rate, code: 'M2P') }
  let(:conversion_attributes) { attributes_for(:conversion_rate) }
  let(:expect_302) { expect(response.status).to eq(302) }
  let(:expect_200) { expect(response.status).to eq(200) }

  describe 'get action conversions without signed in' do
    it 'get #index and response 302' do
      get :index
      expect_302
    end

    it 'get #new and response 302' do
      get :new
      expect_302
    end

    it 'get #edit and response 302' do
      get :edit, params: { id: conversion.id }
      expect_302
    end

    it 'post #create and response 302' do
      post :create, params: { conversion_rate: conversion_attributes }
      expect_302
    end

    it 'patch #update and response 302' do
      patch :update, params: { id: conversion.id, conversion_rate: { description: 'Changed!' } }
      expect_302
    end
  end

  describe 'with admin signed in' do
    let(:admin) { create(:admin) }

    before { sign_in admin }

    describe 'get #index conversion' do
      context 'create 1 more conversion that code 1' do
        let!(:conversion1) { create(:conversion_rate) }

        it 'return 200 and 2 conversions' do
          get :index
          expect_200
          expect(ConversionRate.count).to eq(2)
        end
      end

      context 'create 2 conversions with code 1' do
        it 'will be conflict' do
          expect { create_list(:conversion_rate, 2) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    describe 'get #new conversion' do
      it 'return 200 and render new page' do
        get :new
        expect_200
        expect(response.body).to include('Create new conversion')
      end
    end

    describe 'get #edit conversion' do
      it 'return 200 and info if valid id' do
        get :edit, params: { id: conversion.id }
        expect_200
        expect(response.body).to include(conversion.description)
      end

      it 'return 200 and record not found if invalid id' do
        get :edit, params: { id: conversion.id + 100 }
        expect(response.status).to eq(404)
        expect(response.body).to include('Record Not Found')
      end
    end

    describe 'post #create conversion' do
      context 'add new record that did not exist before' do
        let(:action) { post :create, params: { conversion_rate: conversion_attributes } }

        it 'create new record' do
          expect(ConversionRate.count).to eq(1)
          expect { action }.to change(ConversionRate, :count).by(1)
          expect(ConversionRate.count).to eq(2)
          expect(action).to redirect_to conversion_rates_path
        end
      end

      context 'add record that already exist' do
        let(:conversion_attributes) { attributes_for(:conversion_rate, code: 'M2P') }
        let(:action) { post :create, params: { conversion_rate: conversion_attributes } }

        it 'reject to create new record' do
          expect(ConversionRate.count).to eq(1)
          expect { action }.to change(ConversionRate, :count).by(0)
          expect(ConversionRate.count).to eq(1)
        end
      end

      context 'invalid validation' do
        let(:conversion_attributes) { attributes_for(:conversion_rate, money: 10_000_000) }
        let(:action) { post :create, params: { conversion_rate: conversion_attributes } }

        it 'reject to create new record' do
          expect(ConversionRate.count).to eq(1)
          expect { action }.to change(ConversionRate, :count).by(0)
          expect(ConversionRate.count).to eq(1)
        end
      end
    end

    describe 'patch #update conversion' do
      context 'test uniqueness code' do
        let!(:p2m) { create(:conversion_rate) }

        it 'can not update because conversion exist' do
          patch :update, params: { id: p2m.id, conversion_rate: { code: 'M2P' } }
          expect_200
          expect(response.body).to include('Code existed')
        end

        it 'can not update because blank code' do
          patch :update, params: { id: p2m.id, conversion_rate: { code: '' } }
          expect_200
          expect(response.body).to include('blank')
        end

        it 'update a record if valid info' do
          patch :update, params: { id: p2m.id, conversion_rate: { description: 'Changed' } }
          expect_302
          p2m.reload
          expect(p2m.description).to eq('Changed')
        end
      end
    end
  end
end
