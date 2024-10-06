class DepositsController < ApplicationController
  load_and_authorize_resource

  def index
    
    @upcoming_bookings = Booking.next_24h_checkins.decorate
    @previous_bookings = Booking.past_bookings.limit(20).decorate

  end

end
