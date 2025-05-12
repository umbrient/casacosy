# frozen_string_literal: true

class PopulateApartmentWifiDetails < ActiveRecord::Migration[7.0]
  def up
    Apartment.find_by(name: 'Casa Sage').update(wifi_name: 'TNCAP73CE0B')
    Apartment.find_by(name: 'Casa Sage').update(wifi_password: 'zpfzmyedzg2kq4YN')

    Apartment.find_by(name: 'Casa Maroon').update(wifi_name: 'Flat 46, 5th Floor, 48 Mason Way, B15 2EE')
    Apartment.find_by(name: 'Casa Maroon').update(wifi_password: 'Flat 46, 5th Floor, 48 Mason Way, B15 2EE')

    Apartment.find_by(name: 'Casa Pearl').update(wifi_name: 'TNCAP74D9FB')
    Apartment.find_by(name: 'Casa Pearl').update(wifi_password: 'cRkxcPsHsxhHJNZX')

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
