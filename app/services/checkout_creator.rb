# frozen_string_literal: true

class CheckoutCreator
  # test
  Stripe.api_key = Settings.stripe.secret_key
  URL = { host: Rails.application.config.action_controller.default_url_options[:host] }.freeze
  SUCCESS_CHECKOUT_URL = Rails.application.routes.url_helpers.success_checkout_url(URL)
  CANCEL_CHECKOUT_URL = Rails.application.routes.url_helpers.cancel_checkout_url(URL)

  def self.call(order)
    if order.event.ticket_price == 0.0
      order.status = :success
      order.save
      TicketSender.call order
      OpenStruct.new(url: SUCCESS_CHECKOUT_URL)
    else
      Stripe::Checkout::Session
        .create({
                  payment_method_types: ['card'],
                  line_items: [{
                    name: order.event.title,
                    amount: order.event.ticket_price_cents,
                    currency: 'usd',
                    quantity: order.quantity
                  }],
                  mode: 'payment',
                  success_url: SUCCESS_CHECKOUT_URL,
                  cancel_url: CANCEL_CHECKOUT_URL,
                  customer: order.user.stripe_id
                })
    end
  end
end
