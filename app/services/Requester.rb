class Requester 

  def process(booking)

  end

  def process_batch 
    # remember to only capture bookings made AFTER our go-live date on deposits
    bookings = Booking.next_24h_checkins

    booking.each do |b| 
        email = b.guest_email

        


    end
    
  end


end