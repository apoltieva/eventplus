# frozen_string_literal: true
require_relative '../../lib/exceptions'

class EventHandler
  def self.handle(event)
    if event.type == 'checkout.session.completed'
      session = event.data.object
      customer, order = find_customer_and_order(session)
      if session.payment_status == 'paid'
        order.status = :success
        TicketSender.send_tickets_for order
      else
        order.status = :failure
        FailureMailer.with(customer: customer)
                     .inform_about_checkout_failure.deliver_later
      end
      order.stripe_id = session.id
      order.save
    else
      raise Exceptions::InvalidEventType
    end
  end

  def self.find_customer_and_order(session)
    customer = Customer.find_by(stripe_id: session.customer)
    [customer, customer.orders.where(status: :created).last]
  end
end
