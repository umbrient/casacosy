class BookingDecorator < Draper::Decorator
  delegate_all

  def deposit_status 
    action = object&.requests&.deposit&.last&.action_past_tense
    action = Request.request_actions['not_requested'] if action.nil? 

    h.content_tag(:span, action.upcase, class: 'badge text-bg-warning deposit-tag', style: 'cursor:pointer', data: { type: 'deposit'} )
  end

  def id_status 
    action = object&.requests&.id&.last&.action_past_tense
    action = Request.request_actions['not_requested'] if action.nil? 

    h.content_tag(:span, action.upcase, class: 'badge text-bg-warning id-tag', style: 'cursor:pointer', data: { type: 'id'} )
  end

  def terms_status 
    action = object&.requests&.terms&.last&.action_past_tense
    action = Request.request_actions['not_requested'] if action.nil? 

    h.content_tag(:span, action.upcase, class: 'badge text-bg-warning terms-tag', style: 'cursor:pointer', data: { type: 'terms'} )
  end

end
