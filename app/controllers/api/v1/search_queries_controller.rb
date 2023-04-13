# frozen_string_literal: true

module Api
  module V1
    class SearchQueriesController < ApplicationController
      def search
        query = params[:query]

        # Generate the ILIKE conditions based on the keywords
        conditions = query.scan(/\S+/).map do |word|
          sanitized_word = ActiveRecord::Base.sanitize_sql_like(word)
          "query ILIKE '%#{sanitized_word}%'"
        end.join(' AND ')

        # Use SELECT DISTINCT ON to remove duplicate queries
        sql_query = "SELECT DISTINCT ON (query) * FROM search_queries WHERE (#{conditions}) ORDER BY query, created_at DESC LIMIT 5"
        @search_results = SearchQuery.find_by_sql(sql_query)

        render json: { results: @search_results }, status: :ok
      end

      def create
        query_params = search_query_params
        query = query_params[:query]
        ip_address = query_params[:ip_address]

        if valid_query?
          # Find the existing query by the same user, or initialize a new one
          @search_query = SearchQuery.find_or_initialize_by(query:, ip_address:)

          # Increment the counter if the record exists, or set it to 1 for a new record
          @search_query.counter += 1

          if @search_query.save
            render json: @search_query, status: :created
          else
            render json: @search_query.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Invalid query' }, status: :bad_request
        end
      end

      def most_asked_by_users
        result = SearchQuery.find_by_sql('SELECT query, counter, COUNT(*) as occurrences FROM search_queries GROUP BY query, counter ORDER BY occurrences DESC LIMIT 5')
        render json: result
      end

      def keywords
        time_range = params[:time_range] || 'today'
        limit = params[:limit].to_i || 5
        word_list = ["react", "emil", "ruby", "ruby on rails", "redux","helpjuice", "service", "company", "developer", "Javascript", "sql","programming", "language"] # your list of words
      
        start_time =
          case time_range
          when 'year' then 1.year.ago
          when 'month' then 1.month.ago
          when 'week' then 1.week.ago
          else Time.zone.now.beginning_of_day
          end
      
        queries = SearchQuery.where(created_at: start_time..Time.current)
        words = queries.map(&:query).flat_map { |q| q.scan(/\w+/) }
        keywords = words.select { |word| word_list.include?(word.downcase) }
                        .group_by(&:downcase)
                        .transform_values(&:size)
                        .sort_by { |_, count| -count }
                        .first(limit)
                        .map { |word, count| { word: word.capitalize, count: count } }
      
        render json: keywords
      end
      

      def searches_by_hour_in_week
        start_time = 1.week.ago
        end_time = Time.zone.now

        # Group search queries by hour in the week
        query = <<-SQL
      SELECT EXTRACT(DOW FROM created_at) AS dow,
             EXTRACT(HOUR FROM created_at) AS hour,
             COUNT(*) AS count
      FROM search_queries
      WHERE created_at BETWEEN '#{start_time}' AND '#{end_time}'
      GROUP BY EXTRACT(DOW FROM created_at), EXTRACT(HOUR FROM created_at)
        SQL

        search_counts = SearchQuery.find_by_sql(query)

        # Convert results to a hash of hashes
        results = {}
        7.times do |dow|
          results[dow] = {}
          24.times do |hour|
            results[dow][hour] = 0
          end
        end

        search_counts.each do |count|
          dow = count.dow.to_i
          hour = count.hour.to_i
          results[dow][hour] = count.count.to_i
        end

        render json: results
      end

      private

      def search_query_params
        params.require(:search_query).permit(:query, :ip_address)
      end

      # This method checks if the query is valid or not.
      # A query is valid if it ends with a question mark or if it contains at least 3 words with 3 or more characters each.

      def valid_query?
        query = search_query_params[:query]
        return false if query.blank?
        return true if query.end_with?('?')

        words = query.scan(/\w+/)
        words_with_3_or_more_chars = words.select { |word| word.length >= 3 }
        return true if words_with_3_or_more_chars.size >= 3

        false
      end
    end
  end
end
