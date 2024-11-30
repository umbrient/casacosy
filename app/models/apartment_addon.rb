class ApartmentAddon < ApplicationRecord
  belongs_to :apartment 
  belongs_to :addon
end
