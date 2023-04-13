# frozen_string_literal: true

# app/models/search_query.rb

class SearchQuery < ApplicationRecord
  after_initialize :set_defaults

  validates :query, presence: true, length: { maximum: 255 }
  validates :ip_address, presence: true

  private

  # set default count to 0
  def set_defaults
    self.counter ||= 0 if has_attribute?(:counter)
  end
end
