class CreateBookingAddonOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_addon_options do |t|
      t.references :booking 
      t.references :addon_option
      t.integer :quantity
      t.boolean :yes_or_no
      t.text :text_value
      t.text :notes
      t.timestamps
    end
  end
end
