# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[7.0]
  def up
    Addon.create([
      { 
        name: 'Early Check-In', 
        description: 'Our standard check-in time is X, this add-on allows you to check in earlier than that, depending on how many hours are selected.',
        price_pennies: 1000, type: 'quantity',
        min: 0,
        max: 3 
      },

      { 
        name: 'Late Check-Out', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
        price_pennies: 1000, type: 'quantity',
        min: 0,
        max: 3 
      },

      { 
        name: '', 
        description: 'Includes',
        price_pennies: 1000, type: 'quantity',
        min: 0,
        max: 3 
      }

    ])

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
