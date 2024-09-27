class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :user_id 
      t.string :feedItemUid 
      t.decimal :amount_pennies
      t.string :direction
      t.string :status
      t.string :source
      t.string :account_name
      t.datetime :transaction_timestamp
      t.string :reference
      t.timestamps
    end
  end
end
