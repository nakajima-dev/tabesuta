class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.string :number
      t.references :user, foreign_key: true

      t.timestamps
      
      t.index [:user_id, :number], unique: true
    end
  end
end
