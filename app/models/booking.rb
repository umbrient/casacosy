class Booking < ApplicationRecord

  scope :last_20, -> { where('arrival >= ?', Date.today - 15.days) }
  scope :not_cancelled, -> { where.not(booking_type: 'cancellation') }
  scope :departing_today, -> { where(departure: Date.today ).not_cancelled }
  scope :departing_tomorrow, -> { where(departure: Date.today + 1.day ).not_cancelled }
  
  scope :current_bookings, -> do
  cutoff_time = Time.zone.parse("#{Date.today} 10:00")

   checkout_today_or_tomorrow = Time.current < cutoff_time ? Date.today : Date.tomorrow
   checkin_today_or_tomorrow = Time.current < cutoff_time ? Date.yesterday : Date.today
  

  last_20.not_cancelled.where('arrival <= ? AND departure >= ?', checkin_today_or_tomorrow, checkout_today_or_tomorrow)
                       .order(departure: :asc)
  end

  scope :past_bookings, -> { last_20.not_cancelled.where("departure <= ?", Date.today).order(departure: :desc) }
  scope :future_bookings, -> { not_cancelled.where("departure > ?", Date.today).order(departure: :asc) }
  scope :next_24h_checkins, -> { not_cancelled.where("arrival >= ? AND arrival < ?", Date.today, Date.tomorrow + 1).order(departure: :asc) }
  scope :bookings_after_date, -> (date) { last_20.not_cancelled.where("departure > ?", date).order(departure: :asc).limit(1) }
  
  belongs_to :channel
  belongs_to :apartment
  has_many :requests

  def guest_count
    (adults.to_i + children.to_i)
  end

  def reservation_id 
    guest_app_url.split('=').last
  end

  def code   
    messages = SmoobuApi.new.get_messages(reservation_id)
    codes = messages['messages'].join.to_s.scan /PIN =&nbsp\;(\d{4})|PIN:(\d{4})|Code: (\d{6})|PIN :(\d{4})|PIN is:(\d{4})/
    code = codes.flatten.compact.uniq.first
    # sage: PIN = 0000
    # grey: PIN:0000
    # navy: PIN is:0000
    # pearl: Code: 000000
  end

end
