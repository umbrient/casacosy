class DepositsController < ApplicationController
  load_and_authorize_resource

  def index
    @upcoming_bookings = Booking.next_48h_checkins.decorate
    @previous_bookings = Booking.past_bookings.limit(20).decorate
  end

  def create_intent
    booking = Booking.find params[:booking_id]

    return unless booking
    
    payment_intent = stripe_api.create_payment_intent(amount_pennies: params[:amount] * 100, description: booking.deposit_description )
    render json: { client_secret: payment_intent.client_secret }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private 

  def stripe_api 
    @stripe_api ||= StripeApi.new
  end 


end
