# frozen_string_literal: true

class AddWageExpenseType < ActiveRecord::Migration[7.0]
  def up
    ExpenseType.create([
      { name: 'Wages' },
    ])
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
