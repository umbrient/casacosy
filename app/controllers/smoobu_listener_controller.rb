class SmoobuListenerController < ApplicationController

  def webhook 
    byebug
    Rails.logger.info "Webhook has been hit."
    sync_bookings
    render json: { status: 'OK' } 
  end
end
