class Apartment < ApplicationRecord

  has_many :bookings

  has_many :apartment_addons
  has_many :addons, through: :apartment_addons

  has_one :key

  scope :active, -> { where(is_enabled: true) } 

  def previous_booking
    bookings.past_bookings.first
  end

  def previous_bookings(n)
    bookings.past_bookings.first(n)
  end

end
