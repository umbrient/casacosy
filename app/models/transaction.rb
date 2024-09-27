class Transaction < ApplicationRecord

  scope :unprocessed, -> { where(processed: false) }
  scope :settled, -> { where(status: :SETTLED) }

end
