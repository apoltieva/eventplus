# frozen_string_literal: true

class TicketMailer < ApplicationMailer
  def mail_tickets
    @user = params[:user]
    mail(to: @user.email, subject: 'Your Event+ tickets')
  end
end
