class ApartmentAddon < ApplicationRecord

  belongs_to :apartment
  belongs_to :addon
  scope :available, -> { where(available: true) }

end
