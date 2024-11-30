class AddSortOrderToAddonOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :addon_options, :sort_order, :integer, default: 0
  end
end
