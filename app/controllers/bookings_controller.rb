class BookingsController < ApplicationController
  load_and_authorize_resource


  def show 
    @booking = Booking.find(params[:id])&.decorate
    redirect_to(root_path) unless @booking
  end 


  def update 
    booking = Booking.find(params[:id])
    return render(json:'Not found') unless booking

    return render(json:'Not found') unless booking.reservation_id == params[:reservation]

    fields = booking_params
    fields.delete(:reservation)

    if booking.update(fields)
      return render json: 'Saved' 
    else 
      return render json: 'Woops!' 
    end 
  end


  private 

  def booking_params 
    params.require(:booking).permit(:guest_input_firstname,:guest_input_lastname,:guest_input_guestcount,:guest_input_email,:guest_input_eta,:guest_input_sofabed,:guest_input_parking, :reservation)
  end


end
