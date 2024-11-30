class AddCheckInAndOutToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :check_in_time, :time, :default => "15:00"
    add_column :bookings, :check_out_time, :time, :default => "10:00"
  end
end
