# app/models/search_query.rb

class SearchQuery < ApplicationRecord
    validates :query, presence: true, length: { maximum: 255 }
    validates :ip_address, presence: true
end
  