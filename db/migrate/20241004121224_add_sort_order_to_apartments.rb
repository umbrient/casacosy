class AddSortOrderToApartments < ActiveRecord::Migration[7.0]
  def change
    add_column :apartments, :sort_order, :integer, :default => 0
  end
end
