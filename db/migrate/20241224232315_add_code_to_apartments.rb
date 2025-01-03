class AddCodeToApartments < ActiveRecord::Migration[7.0]
  def change
    add_column :apartments, :lockbox_pin, :integer
  end
end
