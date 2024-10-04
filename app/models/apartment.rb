class Apartment < ApplicationRecord

  has_many :bookings


  def departure_today? 
    bookings.departing_today.any?
  end

  def departure_tomorrow? 
    bookings.departing_tomorrow.any?
  end

  def current_booking
    bookings.current_bookings.first
  end 

  def previous_booking
    bookings.past_bookings.first
  end



end
