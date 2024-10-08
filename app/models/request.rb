class Request < ApplicationRecord
  
  enum request_type: {
    id: 'Identification',
    deposit: 'Deposit',
    terms: 'Terms & Conditions'
  }

  enum action: {
    not_requested: 'Not Requested',
    requested: 'Requested',
    viewed: 'Viewed',
    signed: 'Signed',
    uploaded: 'Uploaded',
    paid: 'Paid',
    approved: 'Approved',
    cancelled: 'Cancelled',
    unnecessary: 'Unnecessary',
    rejected: 'Rejected',
    re_requested: 'Re-requested',
    other: 'Other'
  }


  belongs_to :booking
  belongs_to :user, optional: true
  
end
