# frozen_string_literal: true

# require_relative '../services/qr_code'
class TicketMailer < ApplicationMailer
  after_action :delete_qr_code
  def mail_tickets
    @user = params[:user]
    @event = params[:event]
    @uuid = params[:uuid]
    @qr = QrCode.generate("#{orders_url}/#{params[:uuid]}")
    attachments.inline['image.png'] = File.read(@qr)
    mail(to: @user.email, subject: 'Your Event+ tickets')
  end

  private

  def delete_qr_code
    @qr = QrCode.generate("#{orders_url}/#{params[:uuid]}")
    File.delete(@qr) if File.exist? @qr
  end
end
