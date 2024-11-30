class AddGuestInputFieldsToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :guest_input_firstname, :string 
    add_column :bookings, :guest_input_lastname, :string 
    add_column :bookings, :guest_input_guestcount, :integer
    add_column :bookings, :guest_input_email, :string
    add_column :bookings, :guest_input_eta, :datetime
  end
end
