class TicketSender
  def self.send_tickets_for(order)
    TicketMailer.with(order: order).mail_tickets.deliver_later
  end
end
