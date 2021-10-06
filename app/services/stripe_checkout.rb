module StripeCheckout
  # test
  Stripe.api_key = Settings.stripe.secret_key

  def self.create_session(order)
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
                success_url: 'http://localhost:3000/success',
                cancel_url: 'http://localhost:3000/cancel',
                customer: order.user.stripe_id
              })
  end
end
