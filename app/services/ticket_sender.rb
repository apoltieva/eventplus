# frozen_string_literal: true

class TicketSender
  def self.call(order)
    TicketMailer.with(order: order).mail_tickets.deliver_later
  end
end
