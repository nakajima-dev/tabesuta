class Deleteshops < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :favorites, :shops
    remove_foreign_key :favorites, :users
  end
end
