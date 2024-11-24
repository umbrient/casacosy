class AddInfoToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :estimated_time, :datetime 
    add_column :bookings, :sofa_bed_setup, :boolean, :default => false
    add_column :bookings, :code, :string
  end
end
