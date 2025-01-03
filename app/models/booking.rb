class Booking < ApplicationRecord

  scope :last_20, -> (date = Date.today) { where('arrival >= ?', date - 15.days) }
  scope :not_cancelled, -> { where.not(booking_type: 'cancellation') }
  scope :no_requests, -> { left_joins(:requests).group(:id).having('COUNT(requests.id) = 0') }
  scope :departing, -> (date = Date.today) { where(departure: date ).not_cancelled }
  
  scope :current_bookings, -> (date = Date.today) do

    cutoff_time = Time.zone.parse("#{date} 10:00")
    current_time_on_date = Time.zone.parse("#{date} #{Time.current.strftime('%H:%M')}")


    checkout_today_or_tomorrow = current_time_on_date < cutoff_time ? date : date + 1.day
    checkin_today_or_tomorrow = current_time_on_date < cutoff_time ? date - 1.day : date
  

    last_20(date).not_cancelled.where('arrival <= ? AND departure >= ?', checkin_today_or_tomorrow, checkout_today_or_tomorrow)
                       .order(departure: :asc)
  end

  scope :past_bookings, -> { last_20.not_cancelled.where("departure <= ?", Date.today).order(departure: :desc) }
  scope :future_bookings, -> { not_cancelled.where("departure > ?", Date.today).order(departure: :asc) }
  scope :next_48h_checkins, -> { not_cancelled.where("arrival >= ? AND arrival < ?", Date.today, Date.tomorrow + 2).order(departure: :asc) }
  scope :next_24h_checkins, -> { not_cancelled.where("arrival >= ? AND arrival < ?", Date.today, Date.tomorrow + 1).order(departure: :asc) }
  scope :bookings_after_date, -> (date) { last_20.not_cancelled.where("departure > ?", date).order(departure: :asc).limit(1) }
  scope :between_dates, ->(from, to) { not_cancelled.where("arrival >= ? AND arrival <= ?", from, to).order(departure: :asc) } 
  
  belongs_to :channel
  belongs_to :apartment
  has_many :requests
  has_many :booking_addon_options

  def guest_count
    (adults.to_i + children.to_i)
  end

  def eta
    guest_input_eta&.strftime("%H:%M")
  end

  def basic_details_given?
    given = true
    cols = Booking.column_names.select { |c| c.include? 'guest_input_' }
    
    cols.each do |c| 
      given = false if self.send(c).nil?
    end

    given
  end

  def pre_checkin_url 
    "/guests/#{reservation_id}/#{auth_code}"
  end

  def awaiting_id? 
    requests.id.last.request_action.requested?
  end 

  def awaiting_deposit?
    requests.deposit.last.request_action.requested?
  end

  def awaiting_terms?
    requests.terms.last.request_action.requested?
  end

  def extras_answered?
    false 
  end

  def reservation_id 
    guest_app_url.split('=').last
  end

  def depositable? 
    data_created_at > '2024-10-01'
  end

  def self.find_by_reservation_id(reservation_id)
    Booking.find_by("guest_app_url LIKE ?", "%#{reservation_id}%")
  end

  def previous_bookings_count 
    Booking.where("(email = ? OR phone = ?) AND id <> ?", email, phone, id).count
  end

  def deposit_description
    "Deposit for #{guest_name} Booking ID #{reference_id} #{(channel.name)}"
  end

  def auth_code 
    messages = SmoobuApi.new.get_messages(reservation_id)
    codes = messages['messages'].join.to_s.scan /\/#{reservation_id}\/(\d{4})/
    code = codes.flatten.compact.uniq.first.to_i
  end

  def generate_lockbox_code
  end 

  def generate_collection_code
    # no need for lockbox ones, as that will already have been generated.
    # we don't generate keynest ones at the same time because of the valid to-from range on keynest keys.
    # We'll only allow early check-in if they've paid
    apartment.key.new_code(self) if apartment.key
  end

  def keycode 
    if apartment.key
     keynest_code
    else 
      code || lockbox_code
    end 
  end

  # legacy
  def code
    messages = SmoobuApi.new.get_messages(reservation_id)
    codes = messages['messages'].join.to_s.scan /PIN =&nbsp\;(\d{4})|code below *(\d{6})|PIN :(\d{4})|PIN is:(\d{4})|Code: (\d{6})|(\d{6})<\/b>/
    code = codes.flatten.compact.uniq.first
    # sage: PIN = 0000
    # grey: PIN:0000
    # navy: PIN is:0000
    # pearl: Code: 000000
  end

  def deposit_expiry_timestamp
    stripe_api.deposit_expiry_timestamp(requests.deposit.last)
  end

  private 

  def stripe_api 
    @stripe_api ||= StripeApi.new
  end

end
