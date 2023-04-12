class AddIndexToSearchQueries < ActiveRecord::Migration[6.1]
  def change
    add_index :search_queries, :query
  end
end
