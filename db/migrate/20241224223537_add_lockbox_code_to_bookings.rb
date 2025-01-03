class AddLockboxCodeToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :lockbox_code, :string
  end
end
