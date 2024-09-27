class CreateApartments < ActiveRecord::Migration[7.0]
  def change
    create_table :apartments do |t|
      t.string :name,  null: false 
      t.timestamps
    end
  end
end
