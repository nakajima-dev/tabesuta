class ChangeColumnToShop < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :shops, :users
  end
end
