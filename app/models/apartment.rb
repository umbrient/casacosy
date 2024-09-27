class Apartment < ApplicationRecord

  has_many :bookings


  def departing_tomorrow?
    bookings.departing_tomorrow.any? ? 'Yes' : 'No'
  end
  
  def departing_today?
    bookings.departing_today.any? ? 'Yes' : 'No'
  end

  def next_booking
    date = current_booking.departure ||= Date.today
    bookings.bookings_after_date(date).first
  end

  def current_booking
    bookings.current_bookings.first
  end

  def current_booking_departing_tomorrow?
    current_booking.departure <= Date.today + 1.day
  end

  def current_booking
    bookings.current_bookings.first
  end

  def previous_booking 
    bookings.past_bookings.first
  end

  def clean_reason 
    if current_booking_departing_tomorrow?
      "<b>#{current_booking.guest_name} (x#{current_booking.guest_count})</b> is checking out, and #{next_or_empty}"
    else 
      "<b>#{current_booking.guest_name} (x#{current_booking.guest_count})</b> is staying until <b>#{current_booking.departure}</b>"
    end 
  end

  def next_or_empty 
    if next_booking.arrival >= Date.today 
      "<b>#{next_booking.guest_name } (x#{next_booking.guest_count})</b> is checking in."
    else
      "<b>nobody</b> is booked immediately after." 
    end 
  end

end
