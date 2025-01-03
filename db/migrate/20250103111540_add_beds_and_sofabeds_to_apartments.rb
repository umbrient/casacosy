class AddBedsAndSofabedsToApartments < ActiveRecord::Migration[7.0]
  def change
    add_column :apartments, :beds, :integer 
    add_column :apartments, :sofabeds, :integer 
  end
end
