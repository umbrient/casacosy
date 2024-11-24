class BookingDecorator < Draper::Decorator
  delegate_all

  def deposit_status 
    the_action = object&.requests&.deposit&.last&.request_action
    action = object&.requests&.deposit&.last&.action_past_tense
    action = Request.request_actions['not_requested'] if action.nil? 
    h.content_tag(:span, action.upcase, class: "badge #{color_map(the_action)} deposit-tag", style: 'cursor:pointer', data: { type: 'deposit'} )
  end

  def active_deposit?
    object&.requests&.deposit&.any? && 
    !object&.requests&.deposit&.last&.capture? && 
    !object&.requests&.deposit&.last&.request? && 
    !object&.requests&.deposit&.last&.release?
  end

  def id_status 
    the_action = object&.requests&.id&.last&.request_action
    action = object&.requests&.id&.last&.action_past_tense
    action = Request.request_actions['not_requested'] if action.nil? 

    h.content_tag(:span, action.upcase, class: "badge #{color_map(the_action)} id-tag", style: 'cursor:pointer', data: { type: 'id'} )
  end

  def terms_status 
    the_action = object&.requests&.terms&.last&.request_action
    action = object&.requests&.terms&.last&.action_past_tense
    action = Request.request_actions['not_requested'] if action.nil? 

    h.content_tag(:span, action.upcase, class: "badge #{color_map(the_action)} terms-tag", style: 'cursor:pointer', data: { type: 'terms'} )
  end

  def link_text 
     "#{object.guest_name} (<i class='bi bi-person'></i>x#{object.guest_count})".html_safe
  end

  def color_map(status) 
    {
      'not_requested': 'text-bg-secondary',
      'request': 'text-bg-warning',
      'viewed': 'text-bg-secondary',
      'signed': 'text-bg-secondary',
      'uploaded': 'text-bg-primary',
      'paid': 'text-bg-primary',
      'approve': 'text-bg-success',
      'cancel': 'text-bg-danger',
      'unnecessary': 'text-bg-success',
      'capture': 'text-bg-info',
      'release': 'text-bg-danger',
      'disapprove': 'text-bg-secondary',
      'other': 'text-bg-secondary'
    }[status&.to_sym] || 'text-bg-secondary'
  end
end
