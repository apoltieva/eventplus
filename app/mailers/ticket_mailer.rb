# frozen_string_literal: true

# require_relative '../services/qr_code'
class TicketMailer < ApplicationMailer
  def mail_tickets
    @user = params[:user]
    @event = params[:event]
    @qr = QrCode.generate('https://github.com/')
    mail(to: @user.email, subject: 'Your Event+ tickets')
  end
end
