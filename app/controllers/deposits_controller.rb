class DepositsController < ApplicationController
  load_and_authorize_resource class: false

  def index
    @upcoming_bookings = Booking.next_48h_checkins.decorate
    @all_bookings = Booking.order(arrival: :desc).paginate(page: params[:page], per_page: 20).decorate
  end
  
end
