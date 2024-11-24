class Apartment < ApplicationRecord

  has_many :bookings

  def previous_booking
    bookings.past_bookings.first
  end

  def previous_bookings(n)
    bookings.past_bookings.first(n)
  end



end
