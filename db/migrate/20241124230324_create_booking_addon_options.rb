class CreateBookingAddonOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_addon_options do |t|
      t.references :booking 
      t.references :addon
      t.references :addon_option
      t.text :option_value
      t.decimal :current_price_pennies
      t.boolean :paid, default: false
      t.text :notes, nullable: true
      t.timestamps
    end
  end
end
