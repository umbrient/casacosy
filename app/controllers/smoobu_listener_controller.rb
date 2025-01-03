class SmoobuListenerController < ApplicationController

  def webhook 
    sync_keys
    sync_bookings
    SendRequestEmailsJob.perform_now
    render json: { status: 'OK' } 
  end
end
