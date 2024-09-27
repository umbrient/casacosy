class AddPaymentMethodToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :payment_method, :string, default: 'business_bank'
  end
end
