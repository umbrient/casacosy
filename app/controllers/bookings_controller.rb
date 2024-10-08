class BookingsController < ApplicationController

  load_and_authorize_resource

  def previous_codes
     
    bid = Booking.find booking_params[:booking_id]
    return unless bid 

    previous_codes = bid.apartment.previous_bookings(10).map do |b|
    
      {
        # name: b.guest_name,
        # number: b.phone,
        date: "#{b.arrival} - #{b.departure}",
        platform: b.channel.name,
        code: b.code
      }
    end        

    render json: previous_codes

  end

  private 

  def booking_params
    params.permit(:booking_id)
  end
end
