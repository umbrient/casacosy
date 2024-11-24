# frozen_string_literal: true

class AddLabourExpenseType < ActiveRecord::Migration[7.0]
  def up
    ExpenseType.create(name: 'Labour')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
