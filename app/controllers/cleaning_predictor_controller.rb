class CleaningPredictorController < ApplicationController

  load_and_authorize_resource class: false

  def index 
    sync_bookings
    
    @apartments = Apartment.all.order(sort_order: :asc)
    @today = Date.today.strftime("%A")
    @tomorrow = (Date.today + 1).strftime("%A")
    @cutoff_time = Time.zone.parse("#{Date.today} 10:00")

  end 
end
