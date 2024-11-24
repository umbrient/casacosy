class CleaningPredictorController < ApplicationController

  load_and_authorize_resource class: false

  def index 
    sync_bookings
  
    @apartments = Apartment.all.order(sort_order: :asc)
    @today = params[:date].nil? ? Date.today : params[:date].to_date
    @todays_day = @today.strftime("%A") 
    @tomorrow = (@today + 1)
    @tomorrows_day = @tomorrow.strftime("%A")
    @cutoff_time = Time.zone.parse("#{@today} 10:00")
    @yesterday = @today - 1.day
  end 
end