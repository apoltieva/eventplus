# frozen_string_literal: true

class TicketMailer < ApplicationMailer
  def mail_tickets
    @user = params[:order].user
    @event = params[:order].event
    attachments.inline['qr.png'] =
      File.read(QrCode.generate("#{orders_url}/#{params[:order].uuid}"))
    @event.pictures.each_with_index do |picture, i|
      attachments["img_#{i}.png"] = picture.blob.download
    end
    mail(to: @user.email, subject: 'Your Event+ tickets')
  end
end
