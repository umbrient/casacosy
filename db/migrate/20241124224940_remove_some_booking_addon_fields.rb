class RemoveSomeBookingAddonFields < ActiveRecord::Migration[7.0]
  def change
     remove_column :booking_addons, :quantity
     remove_column :booking_addons, :amount_paid_pennies
  end
end
