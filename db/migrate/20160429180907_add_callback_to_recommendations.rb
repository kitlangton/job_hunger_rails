class AddCallbackToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :callback, :string
  end
end
