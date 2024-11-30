class BookingAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_addons do |t| 
      t.references :booking
      t.references :addon
      t.text :details
      t.timestamps
    end
  end
end
