class AddEnabledColumnToApartments < ActiveRecord::Migration[7.0]
  def change
    add_column :apartments, :is_enabled, :boolean, default: false
  end
end
