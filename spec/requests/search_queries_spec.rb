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

    end
  end
  path '/api/v1/search' do
    post 'Creates a new search query' do
      tags 'SearchQueries'
      consumes 'application/json'
      parameter name: :search_query, in: :body, schema: {
        type: :object,
        properties: {
          query: { type: :string, description: 'The search query', example: 'What is the weather like today?' },
          ip_address: { type: :string, description: 'The IP address of the user who made the search', example: '192.168.1.1' }
        },
        required: [ 'query', 'ip_address' ]
      }

      response '201', 'search query created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            query: { type: :string },
            ip_address: { type: :string },
            counter: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          },
          required: [ 'id', 'query', 'ip_address', 'counter', 'created_at', 'updated_at' ]

        let(:search_query) { { query: 'What is the weather like today?', ip_address: '192.168.1.1' } }
        run_test!
      end

      response '400', 'bad request' do
        schema type: :object,
          properties: {
            error: { type: :string }
          },
          required: [ 'error' ]

        let(:search_query) { { query: 'invalid', ip_address: '192.168.1.1' } }
        run_test!
      end
    end
  end

  path '/api/v1/search/most_asked_by_users' do
    get 'Retrieves the most frequently asked queries by users' do
      tags 'SearchQueries'
      produces 'application/json'

      response '200', 'successful request' do
        let!(:search_query1) { SearchQuery.create(query: 'What is the weather like today?', ip_address: '1.1.1.1', counter: 5) }
        let!(:search_query2) { SearchQuery.create(query: 'How to cook pasta?', ip_address: '1.1.1.1', counter: 10) }
        let!(:search_query3) { SearchQuery.create(query: 'How to lose weight?', ip_address: '2.2.2.2', counter: 8) }

        schema type: :array,
          items: {
            type: :object,
            properties: {
              query: { type: :string },
              counter: { type: :integer },
              occurrences: { type: :integer }
            },
            required: [ 'query', 'counter', 'occurrences' ]
          }

        run_test!
      end
    end
  end

  path '/api/v1/search/top_keywords' do
    get 'Gets top searched keywords within specified time range' do
      tags 'SearchQueries'
      produces 'application/json'
      parameter name: :time_range, in: :query, type: :string, description: 'Time range to filter search queries (year/month/week/today)'
      parameter name: :limit, in: :query, type: :integer, description: 'Number of top keywords to be returned'
      
      response '200', 'returns top searched keywords' do
        schema type: :object,
          properties: {
            word: { type: :string },
            count: { type: :integer }
          },
          required: [ 'word', 'count' ]

        let(:time_range) { 'year' }
        let(:limit) { 5 }
        before { get "/api/v1/search/top_keywords?time_range=#{time_range}&limit=#{limit}" }

        it 'returns a successful response' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
  path '/api/v1/search/searches_by_hour_in_week' do
    get 'Searches by hour in the week' do
      tags 'SearchQueries'
      produces 'application/json'
  
      response '200', 'successful search by hour in the week' do
        schema type: :object,
          properties: {
            "0": {
              type: :object,
              properties: {
                "0": { type: :integer },
                "1": { type: :integer },
                # ...
                "23": { type: :integer }
              }
            },
            "1": {
              type: :object,
              properties: {
                "0": { type: :integer },
                "1": { type: :integer },
                # ...
                "23": { type: :integer }
              }
            },
            # ...
            "6": {
              type: :object,
              properties: {
                "0": { type: :integer },
                "1": { type: :integer },
                # ...
                "23": { type: :integer }
              }
            }
          }
  
        before { get "/api/v1/search/searches_by_hour_in_week" }
        it 'returns a successful response' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
