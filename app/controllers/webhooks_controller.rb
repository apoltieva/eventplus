class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    # receive POST from Stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Settings.stripe.endpoint_secret # test variant
    # endpoint_secret = Settings.stripe.webhook_secret # production variant

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    # Handle event
    case event.type
    when 'checkout.session.async_payment_failed' || 'checkout.session.expired'
      session = event.data.object
      find_customer_and_order(session)
      @order.status = :failure
      FailureMailer.with(customer: @customer)
                   .inform_about_checkout_failure.deliver_later
    when 'checkout.session.async_payment_succeeded'
      checkout = event.data.object
      find_customer_and_order(checkout)
      @order.status = :success
      TicketSender.send_tickets_for @order
    else
      puts "Unhandled event type: #{event.type}"
    end
  end

  private

  def find_customer_and_order(session)
    @customer = Customer.find_by(stripe_id: session.customer)
    @order = @customer.orders.first
  end
end
