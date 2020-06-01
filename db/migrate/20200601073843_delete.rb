class Delete < ActiveRecord::Migration[5.2]
  def change
    drop_table :favorites
    drop_table :shops
  end
end
