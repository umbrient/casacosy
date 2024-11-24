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
      bookings.flatten.each do |booking| 

        unless Apartment.find_by(id: booking['apartment']['id'])
          Apartment.create(id: booking['apartment']['id'], name: booking['apartment']['name'])
        end

        unless Channel.find_by(id: booking['channel']['id'])
          Channel.create(id: booking['channel']['id'], name: booking['channel']['name'])
        end

        if Booking.find_by(reference_id: booking['reference-id']) 
          existing = Booking.find_by(reference_id: booking['reference-id']) 
          if booking['type'] != existing.booking_type 
            existing.update(booking_type: booking['type'])
          end 
          next
        end

        payment_charge = 0 
        
        if booking['channel']['name'] == 'Booking.com'
          payment_charge = ((0.0130 * booking['price'].to_f))
        end 

        new_bookings << {
          reference_id: booking['reference-id'],
          booking_type: booking['type'],
          arrival: booking['arrival'],
          departure: booking['departure'],
          data_created_at: booking['created-at'],
          data_modified_at: booking['modifiedAt'],
          apartment_id: Apartment.find(booking['apartment']['id']).id,
          channel_id: Channel.find(booking['channel']['id']).id,
          guest_name: booking['guest-name'],
          firstname: booking['firstname'],
          lastname: booking['lastname'],
          email: booking['email'],
          phone: booking['phone'],
          adults: booking['adults'],
          children: booking['children'],
          check_in: booking['check-in'],
          check_out: booking['check-out'],
          notice: booking['notice'],
          assistant_notice: booking['assistant-notice'],
          price: booking['price'],
          price_details: booking['price-details'],
          city_tax: booking['city-tax'],
          price_paid: booking['price-paid'],
          commission_included: booking['commission-included'],
          payment_charge: payment_charge,
          prepayment: booking['prepayment'],
          prepayment_paid: booking['prepayment-paid'],
          deposit: booking['deposit'],
          deposit_paid: booking['deposit-paid'],
          language: booking['language'],
          guest_app_url: booking['guest-app-url'],
          is_blocked_booking: booking['is-blocked-booking'],
          guest_id: booking['guestId']
      }


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
end
