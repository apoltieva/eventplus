# frozen_string_literal: true

module Checkout
  # test
  Stripe.api_key = Settings.stripe.secret_key

  def self.create_session(order)
    if order.event.ticket_price == 0.0
      order.status = :success
      order.save
      TicketSender.send_tickets_for order
      OpenStruct.new(url: success_checkout_url)
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
                  success_url: success_checkout_url,
                  cancel_url: cancel_checkout_url,
                  customer: order.user.stripe_id
                })
    end
  end

  def self.success_checkout_url
    Rails.application.routes.url_helpers.success_checkout_url(url)
  end

  def self.cancel_checkout_url
    Rails.application.routes.url_helpers.cancel_checkout_url(url)
  end

  def self.url
    {
      host: Rails.application.config.action_controller.default_url_options[:host],
      port: Rails.application.config.action_controller.default_url_options.fetch(:port) { 3000 }
    }
  end
end
