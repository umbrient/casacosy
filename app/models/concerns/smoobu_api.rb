class SmoobuApi < Api

  URI = "https://login.smoobu.com"


  def initialize; end

  def get_all_past_reservations 
    bookings = []
    
    page = 1
    from_date = Booking.all.order(data_created_at: :desc).first&.data_created_at&.strftime('%Y-%m-%d') || '2023-01-01'
    loop do 
      response = conn.get("/api/reservations", { pageSize: 100, page: page, showCancellation: true, excludeBlocked: false, from: from_date }) { |req| req.headers['Api-Key'] = api_key }
      response = JSON.parse(response.body) if response.success?
      bookings << response['bookings']
      break if response['bookings'].count < 100 || response['bookings'].count == 0
      page += 1
    end 

    new_bookings = []

    if bookings

      updates = 0

      bookings.flatten.each do |booking| 

        unless Apartment.find_by(id: booking['apartment']['id'])
          Apartment.create(id: booking['apartment']['id'], name: booking['apartment']['name'])
        end

        unless Channel.find_by(id: booking['channel']['id'])
          Channel.create(id: booking['channel']['id'], name: booking['channel']['name'])
        end

        if Booking.find_by(reference_id: booking['reference-id']) 
          existing = Booking.find_by(reference_id: booking['reference-id']) 
          if something_different?(booking, existing)
            updates += 1
            Rails.logger.info "Something has changed with reservation ID #{existing.reservation_id}"
            existing.update(booking_object(booking, existing))
          end 
          next
        end
        new_bookings << booking_object(booking)
      end
    end

    Booking.create(new_bookings)
    
  end

  def get_messages(reservation_id)
    response = conn.get("/api/reservations/#{reservation_id}/messages?onlyRelatedToGuest=false" ) { |req| req.headers['Api-Key'] = api_key }
    JSON.parse(response.body) if response.success?
  end

   private 

    def api_key 
      @api_key ||= (Rails.application.credentials.dig(:smoobu, :api_key) || ENV['SMOOBU_API_KEY'])
    end

    def booking_object(obj, existing = nil) 

      payment_charge = 0 
        
      if obj['channel']['name'] == 'Booking.com'
        payment_charge = ((0.0130 * obj['price'].to_f))
      end 

      obj = {
        reference_id: obj['reference-id'],
        booking_type: obj['type'],
        arrival: obj['arrival'],
        departure: obj['departure'],
        data_created_at: obj['created-at'],
        data_modified_at: obj['modifiedAt'],
        apartment_id: Apartment.find(obj['apartment']['id']).id,
        channel_id: Channel.find(obj['channel']['id']).id,
        guest_name: obj['guest-name'],
        firstname: obj['firstname'],
        lastname: obj['lastname'],
        email: obj['email'],
        phone: obj['phone'],
        adults: obj['adults'],
        children: obj['children'],
        check_in: obj['check-in'],
        check_out: obj['check-out'],
        notice: obj['notice'],
        assistant_notice: obj['assistant-notice'],
        price: obj['price'],
        price_details: obj['price-details'],
        city_tax: obj['city-tax'],
        price_paid: obj['price-paid'],
        commission_included: obj['commission-included'],
        payment_charge: payment_charge,
        prepayment: obj['prepayment'],
        prepayment_paid: obj['prepayment-paid'],
        deposit: obj['deposit'],
        deposit_paid: obj['deposit-paid'],
        language: obj['language'],
        guest_app_url: obj['guest-app-url'],
        is_blocked_booking: obj['is-blocked-booking'],
        guest_id: obj['guestId'],
        lockbox_code: format('%04d', rand(0..9999))
      }
      
      return obj

    end 

    def something_different?(booking, existing)  
      [
        booking['type'] == existing.booking_type,
        booking['children'] == existing.children,
        booking['adults'] == existing.adults,
        booking['arrival'].to_date == existing.arrival,
        booking['departure'].to_date == existing.departure,
        booking['price'] == existing.price,
    ].include? false
    end

end
