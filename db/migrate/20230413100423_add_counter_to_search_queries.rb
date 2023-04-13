class AddCounterToSearchQueries < ActiveRecord::Migration[7.0]
  def change
    add_column :search_queries, :counter, :integer, default: 0
  end
end
