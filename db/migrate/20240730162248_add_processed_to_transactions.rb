class AddProcessedToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :processed, :boolean, default: :false 
  end
end
