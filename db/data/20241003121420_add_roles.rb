# frozen_string_literal: true

class AddRoles < ActiveRecord::Migration[7.0]
  def up
    Role.create([
      { name: 'Admin' },
      { name: 'Manager' },
      { name: 'Cleaner' },
      { name: 'VA' },
      { name: 'Guest' }
    ])
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
