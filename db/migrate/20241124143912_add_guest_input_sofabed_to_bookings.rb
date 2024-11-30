class AddGuestInputSofabedToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :guest_input_sofabed, :boolean, default: false
  end
end
