# STRIPE_SECRET_KEY / STRIPE_PUBLISHABLE_KEY override the encrypted credentials, so a
# staging deploy can run against Stripe test mode while sharing production credentials.
Rails.application.config.x.stripe_secret_key =
  ENV['STRIPE_SECRET_KEY'].presence || Rails.application.credentials.dig(:stripe, :secret_key)
Rails.application.config.x.stripe_publishable_key =
  ENV['STRIPE_PUBLISHABLE_KEY'].presence || Rails.application.credentials.dig(:stripe, :publishable_key)

# Staging must never be able to touch live Stripe (it holds a copy of real bookings).
if ENV['PAGEFU_STAGING'].present? &&
   !(Rails.application.config.x.stripe_secret_key.to_s.start_with?('sk_test_') &&
     Rails.application.config.x.stripe_publishable_key.to_s.start_with?('pk_test_'))
  abort 'PAGEFU_STAGING is set but Stripe keys are not test-mode keys; refusing to boot.'
end

Stripe.api_key = Rails.application.config.x.stripe_secret_key
