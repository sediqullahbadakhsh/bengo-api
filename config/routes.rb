# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      post 'search', to: 'search_queries#create'
      get 'search', to: 'search_queries#search'
      get 'search/top_keywords', to: 'search_queries#keywords'
      get 'search/most_asked_by_users', to: 'search_queries#most_asked_by_users'
      get 'search/searches_by_hour_in_week', to: 'search_queries#searches_by_hour_in_week'
    end
  end
end
