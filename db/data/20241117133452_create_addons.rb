# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[7.0]
  def up
    Addon.create([
      { 
        name: 'Early Check-In', 
        description: 'Our standard check-in time is X, this add-on allows you to check in earlier than that, depending on how many hours are selected.',
      },

      { 
        name: 'Late Check-Out', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: 'Netflix Access', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: 'Rose Petals on bed', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: 'Balloons', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: 'Surprise Card', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: 'Shampoo Set', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: 'Gated Parking', 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: "Kid's Play Set", 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },
      
      { 
        name: "Toothbrush & Paste", 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: "Extra Towel", 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: "Extra Keys", 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

      { 
        name: "Movie Night", 
        description: 'Our standard check-out time is X, this add-on allows you to check out later than that, depending on how many hours are selected.',
      },

    ])

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
