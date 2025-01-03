class AddExtrasPaymentMethodTypeColumnToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :extras_payment_method, :string, default: 'deposit'
  end
end
