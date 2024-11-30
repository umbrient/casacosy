class AddDetailsToAddonOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :addon_options, :name, :string
    add_column :addon_options, :description, :text
    add_column :addon_options, :price_pennies_each, :decimal
    add_column :addon_options, :quantifiable, :boolean, default: false
    add_column :addon_options, :quantifiable_text, :string
    add_column :addon_options, :booleanable, :boolean, default: false
    add_column :addon_options, :textable, :boolean, default: false
    add_column :addon_options, :min, :integer, default: 1
    add_column :addon_options, :max, :integer, default: 10
  end
end
