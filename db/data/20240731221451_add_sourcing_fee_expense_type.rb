# frozen_string_literal: true

class AddSourcingFeeExpenseType < ActiveRecord::Migration[7.0]
  def up
    ExpenseType.create(name: 'Sourcing fee')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
