class Apartment < ApplicationRecord

  has_many :bookings

  has_many :apartment_addons
  has_many :addons, through: :apartment_addons

  def previous_booking
    bookings.past_bookings.first
  end

  def previous_bookings(n)
    bookings.past_bookings.first(n)
  end



end
