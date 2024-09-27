class CreateApartmentTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :apartment_transactions do |t|
      t.references :transaction, foreign_key: true
      t.references :apartment, foreign_key: true
      t.decimal :amount
      t.text :notes
      t.timestamps
    end
  end
end
