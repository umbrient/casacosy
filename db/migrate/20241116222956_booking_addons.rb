class BookingAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_addons do |t| 
      t.references :booking
      t.references :addon
      t.integer :quantity
      t.decimal :amount_paid_pennies
      t.text :details

      t.timestamps
    end
  end
end
