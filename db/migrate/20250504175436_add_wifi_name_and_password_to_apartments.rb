class AddWifiNameAndPasswordToApartments < ActiveRecord::Migration[7.0]
  def change
    add_column :apartments, :wifi_name, :string
    add_column :apartments, :wifi_password, :string
  end
end
