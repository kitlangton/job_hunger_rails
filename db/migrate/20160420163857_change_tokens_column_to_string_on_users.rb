class ChangeTokensColumnToStringOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :tokens, :string
  end
end
