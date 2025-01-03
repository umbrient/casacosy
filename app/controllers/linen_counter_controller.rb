class LinenCounterController < ApplicationController

  load_and_authorize_resource class: false

  def index
    
    from = params[:from].presence || Date.today
    to = params[:to].presence || Date.today

    @data = []
    Apartment.all.each do |a| 
      bookings = a.bookings.between_dates(from, to)
      
      @data << {
        apartment: a, 
        bookings: bookings.count,
        guests: bookings.map(&:guest_count).sum
      }
    end


  end
end
