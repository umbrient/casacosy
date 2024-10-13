class Request < ApplicationRecord
  
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
    approve: 'Approved',
    cancel: 'Cancelled',
    unnecessary: 'Unnecessary',
    Disapprove: 'Disapproved',
    re_request: 'Re-requested',
    other: 'Other'
  }

  belongs_to :booking
  belongs_to :user, optional: true

  def action_past_tense 
    map = {
      request: 'requested',
      viewed: 'viewed',
      signed: 'signed',
      uploaded: 'uploaded',
      paid: 'Paid',
      approve: 'Approved',
      cancel: 'Cancelled',
      unnecessary: 'unnecessary',
      Disapprove: 'Disapproved',
      re_request: 're_requested',
      other: 'other',
    } 
    map.include?(request_action.to_sym) ? map[request_action.to_sym] : request_action
  end
  
end
