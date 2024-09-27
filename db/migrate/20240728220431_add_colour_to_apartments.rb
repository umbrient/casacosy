
class AddColourToApartments < ActiveRecord::Migration[7.0]
  def change
    add_column :apartments, :colour, :string, default: :primary 
  end
end
