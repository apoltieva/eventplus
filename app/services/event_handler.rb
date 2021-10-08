class EventHandler
  def self.handle(event)
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
      render json: { error: "Unhandled event type: #{event.type}" }, status: :bad_request
    end
  end

  private

  def find_customer_and_order(session)
    @customer = Customer.find_by(stripe_id: session.customer)
    @order = @customer.orders.first
  end
end
