class Booking < ApplicationRecord

  scope :last_20, -> { where('arrival >= ?', Date.today - 15.days) }
  scope :not_cancelled, -> { where.not(booking_type: 'cancellation') }
  scope :departing_today, -> { last_20.not_cancelled.where(departure: Date.today )}
  scope :departing_tomorrow, -> { last_20.not_cancelled.where(departure: Date.today + 1.day )}
  scope :current_bookings, -> { last_20.not_cancelled.where('arrival <= ? AND departure >= ?', Date.today, Date.today).order(departure: :asc) }
  scope :past_bookings, -> { last_20.not_cancelled.where("departure < ?", Date.today).order(departure: :desc) }
  scope :future_bookings, -> { last_20.not_cancelled.where("departure > ?", Date.today).order(departure: :asc).limit(1) }
  scope :bookings_after_date, -> (date) { last_20.not_cancelled.where("departure > ?", date).order(departure: :asc).limit(1) }
  


  belongs_to :apartment


  def guest_count
    (adults + children) rescue 'Unknown'
  end



end
