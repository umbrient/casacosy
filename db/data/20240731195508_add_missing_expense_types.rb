# frozen_string_literal: true

class AddMissingExpenseTypes < ActiveRecord::Migration[7.0]
  def up
    ExpenseType.create([
      { name: 'Amazon gift card' },
      { name: 'Software' },
      { name: 'Deposit' }
    ])
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
