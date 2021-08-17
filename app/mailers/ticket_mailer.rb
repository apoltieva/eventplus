# frozen_string_literal: true

class TicketMailer < ApplicationMailer
  def mail_tickets
    @user = params[:user]
    @event = params[:event]
    @uuid = params[:uuid]
    @qr = QrCode.generate("#{orders_url}/#{params[:uuid]}")
    attachments.inline['qr.png'] = File.read(@qr)
    @event.pictures.each_with_index do |picture, i|
      attachments["img_#{i}.png"] = picture.blob.download
    end
    mail(to: @user.email, subject: 'Your Event+ tickets')
  end
end
