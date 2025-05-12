# frozen_string_literal: true

class PopulateApartmentAddresses < ActiveRecord::Migration[7.0]
  def up
    Apartment.find_by(name: 'Casa Sage').update(address: 'Flat 203, 2nd Floor, 3 Helena Street, B1 2AW')
    Apartment.find_by(name: 'Casa Grey').update(address: 'Flat 6, 1st Floor, 20 Bell Barn Road, B15 2DB')
    Apartment.find_by(name: 'Casa Maroon').update(address: 'Flat 46, 5th Floor, 48 Mason Way, B15 2EE')
    Apartment.find_by(name: 'Casa Navy').update(address: 'Flat 9, 1st Floor, 48 Mason Way, B15 2EE')
    Apartment.find_by(name: 'Casa Pearl').update(address: 'Flat 97, 6th Floor, 1 Clive Passage, B4 6HZ')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
