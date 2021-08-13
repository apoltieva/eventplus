class EventDecorator < Draper::Decorator
  delegate_all

  def start_end
    "From: #{object.start_time.strftime("%a %b %e, %R")} till: #{object.end_time.strftime("%a %b %e, %R")}"
  end

  def fee
    object.ticket_price_cents == 0 ? 'FREE' : "#{Money.new(object.ticket_price_cents)} UAH"
  end
end
