class StripeApi < Api

  def initialize 
    Stripe.api_key = api_key
  end

  def create_payment_intent(amount_pennies:, description:, capture: false)
    Stripe::PaymentIntent.create({
      amount: amount_pennies,
      currency: 'gbp',
      capture_method: capture ? 'automatic' : 'manual',
      description: description,
      automatic_payment_methods: { enabled: true },  # Enable automatic payment methods
    })
  end

def deposit_successful?(payment_id)
  begin
    payment_intent = retrieve_payment(payment_id)
    return payment_intent.amount_capturable == 15000
  rescue Stripe::StripeError => e
    return nil
  end
end

def retrieve_payment(payment_id)
  payment_intent_id = payment_id
  begin
    return Stripe::PaymentIntent.retrieve(payment_intent_id)
  rescue Stripe::StripeError => e
    return nil
  end
end

def capture_deposit(payment_intent_id:, amount:) 
  payment_intent = Stripe::PaymentIntent.capture(
    payment_intent_id,
    {
      amount_to_capture: amount
    }
  )
  payment_intent
end

  private 

  def api_key 
    @api_key ||= (Rails.application.credentials.dig(:stripe, :live, :secret_key) || ENV['STRIPE_API_KEY'])
  end

end