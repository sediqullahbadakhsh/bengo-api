class Api::V1::SearchQueriesController < ApplicationController

  # This method is called when a user searches for something.
  # If the query is valid, and not chaced, it is saved in the database.
  # If the query is invalid, an error message is returned.
  # If the query is valid, and the search results are already cached, the cached results are returned.

  def search
    if valid_query?
      @search_query = SearchQuery.find_or_initialize_by(query: params[:query])
      @search_query.ip_address = request.remote_ip
      @search_query.save!
      response = Rails.cache.fetch(cache_key) do
        # perform search and generate response
      end
      render json: response
    else
      render json: { error: "Invalid query" }, status: :bad_request
    end
  end

  private
  # This method checks if the query is valid or not.
  # A query is valid if it ends with a question mark or if it contains at least 3 words with 3 or more characters each.

  def valid_query?
    query = params[:query]
    return false if query.blank?
    return true if query.end_with?("?")
    words = query.scan(/\w+/)
    words_with_3_or_more_chars = words.select { |word| word.length >= 3 }
    return true if words_with_3_or_more_chars.size >= 3
    false
  end

# This method generates a cache key for the search results.
  def cache_key
    "search_results_#{params[:query]}"
  end

end
