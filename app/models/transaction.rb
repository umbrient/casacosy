class Transaction < ApplicationRecord

  scope :unprocessed, -> { where(processed: false) }
  scope :settled, -> { where(status: :SETTLED) }
  scope :out, -> { where(direction: :OUT) }
  scope :in, -> { where(direction: :IN) }

end
