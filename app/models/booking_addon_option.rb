class BookingAddonOption < ApplicationRecord
  belongs_to :booking 
  belongs_to :addon_option 
  has_one :addon, through: :addon_option
  
  scope :unpaid, -> { where(paid: false) }
  scope :paid, -> { where(paid: true) }
end
