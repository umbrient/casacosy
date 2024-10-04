class Booking < ApplicationRecord

  scope :last_20, -> { where('arrival >= ?', Date.today - 15.days) }
  scope :not_cancelled, -> { where.not(booking_type: 'cancellation') }
  scope :departing_today, -> { where(departure: Date.today ).not_cancelled }
  scope :departing_tomorrow, -> { where(departure: Date.today + 1.day ).not_cancelled }
  
  scope :current_bookings, -> do
  cutoff_time = Time.zone.parse("#{Date.today} 10:00")

  checkin_today_or_tomorrow = Time.current < cutoff_time ? Date.today : Date.tomorrow
  checkout_today_or_tomorrow = Time.current < cutoff_time ? Date.yesterday : Date.today
  

  last_20.not_cancelled.where('arrival <= ? AND departure >= ?', checkout_today_or_tomorrow, checkin_today_or_tomorrow)
                       .order(departure: :asc)
  end

  scope :past_bookings, -> { last_20.not_cancelled.where("departure <= ?", Date.today).order(departure: :desc) }
  scope :future_bookings, -> { last_20.not_cancelled.where("departure > ?", Date.today).order(departure: :asc).limit(1) }
  scope :bookings_after_date, -> (date) { last_20.not_cancelled.where("departure > ?", date).order(departure: :asc).limit(1) }
  
  belongs_to :channel


  belongs_to :apartment


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
    # sage: PIN = 4828
    # grey: PIN:4908
    # navy: PIN is:2208
    # pearl: Code: 953791
  end

end
