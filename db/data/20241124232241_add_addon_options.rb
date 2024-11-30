# frozen_string_literal: true

class AddAddonOptions < ActiveRecord::Migration[7.0]
  def up

    AddonOption.create([ 

      # Maybe ....
      # If an addon has multiple booleanable options, assume only one can be selected. 

      #  Early check-in
      { addon_id: 1, name: '14:00PM', description: '1 hour earlier.', booleanable: true, price_pennies_each: 1000, sort_order: 0 },
      { addon_id: 1, name: '13:00PM', description: '2 hours earlier.', booleanable: true, price_pennies_each: 2000, sort_order: 1 },
      { addon_id: 1, name: '12:00PM', description: '3 hours earlier.', booleanable: true, price_pennies_each: 3000, sort_order: 2 },

      #  Late check-out
      { addon_id: 2, name: '11:00AM', description: '1 hour later.', booleanable: true, price_pennies_each: 1000, sort_order: 0 },
      { addon_id: 2, name: '12:00PM', description: '2 hours later.', booleanable: true, price_pennies_each: 2000, sort_order: 1 },
      { addon_id: 2, name: '13:00PM', description: '3 hours later.', booleanable: true, price_pennies_each: 3000, sort_order: 2 },

      #  Netflix Access
      { addon_id: 3, name: 'Include', description: 'We will provide you with our Netflix credentials to use for the night. These will be sent to you as part of the check-in instructions.', booleanable: true, price_pennies_each: 1000 },

      #  Rose Petal
      { addon_id: 4, name: 'On how many beds?', description: 'Rose petals sprinkled on the bed.', quantifiable: true, price_pennies_each: 1000, min: 1, max: 4 },

      #  Balloons
      { addon_id: 5, name: 'Include', booleanable: true, price_pennies_each: 1000 },

      #  Surprise Card
      { addon_id: 6, name: 'Card Message?', textable: true, price_pennies_each: 1000 },

      # Shower Set
      { addon_id: 7, name: 'How many sets?', quantifiable: true, price_pennies_each: 1000 },

      # Gated Parking
      { addon_id: 8, name: 'Include', description: 'Your keys will have attached to them a remote to open the secure, gated car-park.', booleanable: true, price_pennies_each: 1000 },

      # Kid's play set
      { addon_id: 9, name: 'Include', booleanable: true, price_pennies_each: 1000 },

      # Toothbrush & Paste
      { addon_id: 10, name: 'How many sets?', quantifiable: true, price_pennies_each: 500 },

      # Extra Towel
      { addon_id: 11, name: 'How many sets?', quantifiable: true, price_pennies_each: 300 },

      # Extra Keys
      { addon_id: 12, name: 'Include', booleanable: true, price_pennies_each: 300 },

      # Movie Night
      { addon_id: 13, name: 'Soft Drink 1', quantifiable: true, price_pennies_each: 200 },
      { addon_id: 13, name: 'Soft Drink 2', quantifiable: true, price_pennies_each: 200 },
      { addon_id: 13, name: 'Soft Drink 3', quantifiable: true, price_pennies_each: 200 },
      { addon_id: 13, name: 'Popcorn', quantifiable: true, price_pennies_each: 400 },


    ])

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
