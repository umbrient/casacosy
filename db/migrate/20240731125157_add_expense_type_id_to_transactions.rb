class AddExpenseTypeIdToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :expense_type_id, :integer, null: true 
  end
end
