class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    # receive POST from Stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    # endpoint_secret = Settings.stripe.endpoint_secret # test variant
    endpoint_secret = Settings.stripe.webhook_secret # production variant

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    # Handle event
    if event.type == 'checkout.session.completed'
      session = event.data.object
      find_customer_and_order(session)
      if session.payment_status == 'paid'
        @order.status = :success
        TicketSender.send_tickets_for @order
      else
        @order.status = :failure
        FailureMailer.with(customer: @customer)
                     .inform_about_checkout_failure.deliver_later
      end
      @order.stripe_id = session.id
      @order.save
    else
      render json: {error: "Unhandled event type: #{event.type}"}, status: :bad_request
    end
  end

  private

  def find_customer_and_order(session)
    @customer = Customer.find_by(stripe_id: session.customer)
    @order = @customer.orders.first
  end
end
