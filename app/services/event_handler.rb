# frozen_string_literal: true

require_relative '../../lib/exceptions'

class EventHandler
  def self.handle(event)
    case event.type
    when 'charge.succeeded'
      session, customer, order = create_session_customer_order(event)
      if session.paid
        set_status_and_stripe_id(order, :success, session.id)
        TicketSender.send_tickets_for order
      else
        set_status_and_stripe_id(order, :failure, session.id)
        FailureMailer.with(customer: customer)
                     .inform_about_checkout_failure.deliver_later
      end
    when 'charge.failed'
      session, customer, order = create_session_customer_order(event)
      set_status_and_stripe_id(order, :failure, session.id)
      Rails.logger.info "Failed payment for order: #{order.id} of customer: #{customer.id}"
    when 'payment_intent.canceled'
      session, _customer, order = create_session_customer_order(event)
      set_status_and_stripe_id(order, :failure, session.id)
    else
      raise Exceptions::InvalidEventType
    end
  end

  def self.set_status_and_stripe_id(order, status, id)
    order.status = status
    order.stripe_id = id
    order.save
  end

  def self.create_session_customer_order(event)
    session = event.data.object
    customer = Customer.find_by(stripe_id: session.customer)
    order = customer.orders.where(status: :created).order(:created_at).last
    [session, customer, order]
  end
end
