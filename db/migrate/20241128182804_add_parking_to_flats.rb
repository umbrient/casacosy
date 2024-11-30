class AddParkingToFlats < ActiveRecord::Migration[7.0]
  def change
    add_column :apartments, :has_parking, :boolean, :default => false
  end
end
