class Request < ApplicationRecord

  scope :not_expired, -> { where(expired: false) }
  
  enum request_type: {
    id: 'Identification',
    deposit: 'Deposit',
    terms: 'Terms & Conditions'
  }

  enum request_action: {
    not_requested: 'Not Requested',
    request: 'Requested',
    viewed: 'Viewed',
    signed: 'Signed',
    uploaded: 'Uploaded',
    paid: 'Paid',
    error: 'Error',
    approve: 'Approved',
    cancel: 'Cancelled',
    unnecessary: 'Unnecessary',
    capture: 'Captured',
    release: 'Released',
    disapprove: 'Disapproved',
    other: 'Other'
  }

  belongs_to :booking
  belongs_to :user, optional: true

  def username
    if user_id.nil?
      'Guest'
    elsif(user_id > 0)
       user.name
    elsif (user_id == -1)
      'Machine'
    end 
  end

  
  def action_past_tense 
    map = {
      request: 'requested',
      viewed: 'viewed',
      signed: 'signed',
      uploaded: 'uploaded',
      paid: 'Paid',
      approve: 'Approved',
      cancel: 'Cancelled',
      unnecessary: 'Unnecessary',
      disapprove: 'Disapproved',
      capture: 'Captured',
      release: 'Released',
      other: 'Other',
    } 
    map.include?(request_action.to_sym) ? map[request_action.to_sym] : request_action
  end
  
end
