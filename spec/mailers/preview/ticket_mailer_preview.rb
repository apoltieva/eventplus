# frozen_string_literal: true

class TicketMailerPreview < ActionMailer::Preview
  def mail_tickets
    @user = User.first
    @event = Event.first
    TicketMailer.with(user: @user, event: @event).mail_tickets
  end
end
