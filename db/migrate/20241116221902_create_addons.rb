class CreateAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :addons do |t|
      t.string :name 
      t.text :description
      t.decimal :price_pennies
      t.string :type
      t.integer :min 
      t.integer :max 
      t.timestamps
    end
  end
end
