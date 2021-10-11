# frozen_string_literal: true
require_relative '../../lib/exceptions'

class EventHandler
  def self.handle(event)
    case event.type
    when 'charge.succeeded'
      session = event.data.object
      customer, order = find_customer_and_order(session)
      if session.paid
        set_status_and_stripe_id(order, :success, session.id)
        TicketSender.send_tickets_for order
      else
        set_status_and_stripe_id(order, :failure, session.id)
        FailureMailer.with(customer: customer)
                     .inform_about_checkout_failure.deliver_later
      end
    when 'charge.failed'
      session = event.data.object
      customer, order = find_customer_and_order(session)
      set_status_and_stripe_id(order, :failure, session.id)
      Rails.logger.info "Failed payment for order: #{order.id} of customer: #{customer.id}"
    when 'payment_intent.canceled'
      session = event.data.object
      order = find_customer_and_order(session)[1]
      set_status_and_stripe_id(order, :failure, session.id)
    else
      raise Exceptions::InvalidEventType
    end
  end

  def self.find_customer_and_order(session)
    customer = Customer.find_by(stripe_id: session.customer)
    [customer, customer.orders.where(status: :created).last]
  end

  def self.set_status_and_stripe_id(order, status, id)
    order.status = status
    order.stripe_id = id
    order.save
  end
end
