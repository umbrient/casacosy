class AddKeynestCodeToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :keynest_code, :string
  end
end
