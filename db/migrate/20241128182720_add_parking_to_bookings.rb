class AddParkingToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :guest_input_parking, :boolean, :default => false
  end
end
