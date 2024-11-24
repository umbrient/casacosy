# frozen_string_literal: true

class AddTaskTypes < ActiveRecord::Migration[7.0]
  def up
    TaskType.create([
      { name: 'Turnover Clean' },
      { name: 'Deep Clean' },
    ])
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
