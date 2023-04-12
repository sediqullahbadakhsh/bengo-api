require 'swagger_helper'

describe 'SearchQueries API', type: :request do
  path '/api/v1/search' do
    get 'Searches for something' do
      tags 'SearchQueries'
      produces 'application/json'
      parameter name: :query, in: :query, type: :string, description: 'The search query', required: true

      response '200', 'successful search' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            query: { type: :string },
            ip_address: { type: :string },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          },
          required: [ 'id', 'query', 'ip_address', 'created_at', 'updated_at' ]

        let(:query) { 'What is your name?' }
        before { get "/api/v1/search?query=#{query}" }
        it 'returns a successful response' do
          expect(response).to have_http_status(200)
        end
      end

      response '400', 'bad request' do
        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: [ 'error' ]

        let(:query) { 'invalid' }
        before { get "/api/v1/search?query=#{query}" }
        it 'returns a bad request response' do
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
