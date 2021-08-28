# frozen_string_literal: true

class EventDecorator < Draper::Decorator
  delegate  :start_time, :end_time, :ticket_price_cents,
            :current_page, :per_page, :offset, :total_entries, :total_pages

  def start_end
    "From: #{object.start_time.strftime('%a %b %e, %R')} " \
    "till: #{object.end_time.strftime('%a %b %e, %R')}"
  end

  def fee
    object.ticket_price_cents.zero? ? 'FREE' : "#{Money.new(object.ticket_price_cents)} UAH"
  end
end
