class Deleteshop < ActiveRecord::Migration[5.2]
  def change
    drop_table :shops
  end
end
