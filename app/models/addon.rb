class Addon < ApplicationRecord
  has_many :apartment_addons
  has_many :addon_options

  has_many :apartments, through: :apartment_addons

  scope :available, -> { joins(:apartment_addons).where(apartment_addons: { available: true }) }

  def immediately_calculate_price? 
    addon_options.count == 1 ? true : false 
  end

end
