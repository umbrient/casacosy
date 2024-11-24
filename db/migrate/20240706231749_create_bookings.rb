class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.string :reference_id, null: true
      t.string :booking_type, null: true
      t.date :arrival, null: true
      t.date :departure, null: true
      t.datetime :data_created_at, null: true
      t.datetime :data_modified_at, null: true
      t.references :apartment, foreign_key: true, null: true
      t.references :channel, foreign_key: true, null: true
      t.string :guest_name
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone
      t.integer :adults, null: true
      t.integer :children, null: true
      t.time :check_in
      t.time :check_out
      t.text :notice
      t.text :assistant_notice
      t.decimal :price, precision: 8, scale: 2, null: true
      t.text :price_details
      t.decimal :city_tax, precision: 8, scale: 2
      t.boolean :price_paid, default: false
      t.decimal :commission_included, precision: 8, scale: 2
      t.decimal :payment_charge, precision: 8, scale: 2, null: true
      t.decimal :prepayment, precision: 8, scale: 2
      t.boolean :prepayment_paid, default: false
      t.decimal :deposit, precision: 8, scale: 2
      t.boolean :deposit_paid, default: false
      t.string :language
      t.string :guest_app_url
      t.boolean :is_blocked_booking, default: false
      t.integer :guest_id, null: true

      t.timestamps
    end

    add_index :bookings, :reference_id
    add_index :bookings, :guest_id
  end
end
