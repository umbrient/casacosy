class BookingsController < ApplicationController

  load_and_authorize_resource
  
  def show 
    @booking = Booking.find(params[:id])&.decorate
    redirect_to(root_path) unless @booking
  end 
  
end
