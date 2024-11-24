class ApartmentAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :apartment_addons do |t| 
      t.references :apartment 
      t.references :addon
      t.boolean :available, default: true
      t.text :notes 

      t.timestamps 
    end
  end
end
