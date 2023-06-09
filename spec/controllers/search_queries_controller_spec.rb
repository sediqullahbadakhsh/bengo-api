# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SearchQueriesController, type: :controller do
  describe '#search' do
    before do
      allow(controller.request).to receive(:remote_ip).and_return('1.1.1.1')
    end

    context 'when the query is valid and ends with ?' do
      let(:query) { 'What is the capital of Egypt?' }

      it 'returns a successful response' do
        get :search, params: { query: }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the query is valid and contains at least 3 words with 3 or more characters each' do
      let(:query) { 'What is the weather like today?' }

      it 'returns a successful response' do
        get :search, params: { query: }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the query is invalid' do
      let(:query) { 'What is your na' }

      it 'does not create a new search query' do
        expect do
          get :search, params: { query: }
        end.to_not change(SearchQuery, :count)
      end
    end
  end

  describe '#valid_query?' do
    it 'returns true for a query that ends with ?' do
      query = 'What is up?'
      get :search, params: { query: }
      expect(response).to have_http_status(:ok)
    end

    it 'returns true for a query that contains at least 3 words with 3 or more characters each' do
      query = 'What is the weather like today'
      get :search, params: { query: }
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when a new user searches for the same query' do
    let(:query) { 'What is the weather like today?' }

    before do
      SearchQuery.create(query:, ip_address: '1.1.1.1')
      allow(controller.request).to receive(:remote_ip).and_return('2.2.2.2')
    end

    it 'returns a successful response' do
      get :search, params: { query: }
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when the same user searches for the same query again' do
    let(:query) { 'What is the capital of Egypt?' }
    let(:ip_address) { '123.45.67.89' }

    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip_address)
      get :search, params: { query: }
    end

    it 'does not create a new search query for the same user' do
      expect do
        get :search, params: { query: }
      end.to_not change(SearchQuery, :count)
    end
  end
end
