class SendRequestEmailsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "::: Start Periodic Emails Job :::"

    # get all future bookings without requests and make requests for 'em
    bookings = Booking.future_bookings.no_requests

    Rails.logger.info "#{bookings.count} bookings are checking in within the next 24h"

    bookings.each do |b|
      perform_one(b)
    end
  end

  def self.perform_one(b)
    id = b.id 
    ref = b.reference_id
    apartment = b.apartment.name 
    name = b.guest_name 
    channel = b.channel.name

    %w(id terms deposit).each do |type|
      # already been done
      if b.requests.send(type).send(type_to_verb(type)).any?
        Rails.logger.info "Skipping Booking ID ##{id} (Ref: #{ref}) (#{name}/#{channel}/#{apartment}) as the '#{type}' action seems to be done?"
        next 
      end

      # is there an open request? create one if not
      req = b.requests.send(type)&.request&.last
      if req.nil? || req.expired?
        if req.nil?
          msg = "No #{type} request yet for Booking ID ##{id} (Ref: #{ref}) (#{name}/#{channel}/#{apartment})"
        elsif req.expired?
          msg = "#{type} request exists but has expired for Booking ID ##{id} (Ref: #{ref}) (#{name}/#{channel}/#{apartment})"
        end 
        
        Rails.logger.info msg

        args = { 
          booking_id: b.id,
          request_type: Request.request_types[type],
          request_action: 'Requested',
          user_id: -1
        }
        if RequestCreator.new(args, true).call
          Rails.logger.info "Created #{type} request for Booking ##{id} (Ref: #{ref}) (#{name}/#{channel}/#{apartment})"
        end 
      else 
        # if it's now less than 6 hours to go until their booking (and this is not done yet)
        # AND it's been at least 12 hours since you received an email about this...
        # send a reminder

        # Somebody books 100 days in advance
        # Somebody books 10 days in advance
        # Somebody books 1 days in advance
        # Somebody books last minute

        # when to send check-in instructions?
        # anytime something gets completed, check if that completes everything. If it does, send instructions. If it doesn't, don't.
        # have two buttons "Receive check-in instructions" which is greyed out until all 3 steps are done. Another button beside it saying "Contact US"
        # in case something's happened or they need further help.

        Rails.logger.info "Need a reminder maybe?"
      end
    end
  end

  private 

  def type_to_verb(type) 
    {
      'id' => 'uploaded',
      'terms' => 'signed',
      'deposit' => 'paid'
    }[type]
  end

end
