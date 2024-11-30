class AddViewedExtrasToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :guest_has_viewed_extras, :boolean, default: false
  end
end
