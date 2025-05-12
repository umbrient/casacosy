class AddStoreDetailsToKey < ActiveRecord::Migration[7.0]
  def change
    add_column :keys, :store_name, :string
    add_column :keys, :store_address, :text
    add_column :keys, :store_times, :string
    add_column :keys, :store_lat, :string
    add_column :keys, :store_lng, :string
  end
end
