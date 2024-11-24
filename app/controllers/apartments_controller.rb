class ApartmentsController < ApplicationController

  load_and_authorize_resource

  def previous_codes     
    a = Apartment.find_by(id: apartment_params[:apartment_id])
    
    previous_codes = a.previous_bookings(10).map do |b|
      {
        # name: b.guest_name,
        # number: b.phone,
        date: "#{b.arrival} - #{b.departure}",
        platform: b.channel.name,
        code: b&.code || 'N/A'
      }
    end        

    render json: previous_codes

  end


  private 

  def apartment_params
    params.permit(:apartment_id)
  end


end
