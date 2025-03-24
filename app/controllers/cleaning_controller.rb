class CleaningController < ApplicationController
  load_and_authorize_resource class: false


  def index
    @today = params[:date].nil? ? Date.today : params[:date].to_date
    @todays_day = @today.strftime("%A") 
    @tomorrow = (@today + 1)
    @tomorrows_day = @tomorrow.strftime("%A")
    @cutoff_time = Time.zone.parse("#{@today} 10:00")
    @yesterday = @today - 1.day

    @apartments = Apartment.active.order(sort_order: :asc) do |a| 
      a.bookings.departing(@today).any? || a.bookings.departing(@tomorrow).any? 
    end 
    
    
  end 
end
