class RemoveFieldsFromAddons < ActiveRecord::Migration[7.0]
  def change
    remove_column :addons, :price_pennies
    remove_column :addons, :type
    remove_column :addons, :min 
    remove_column :addons, :max
  end
end
