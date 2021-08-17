# frozen_string_literal: true

# require_relative '../../../app/services/qr_code'
class TicketMailerPreview < ActionMailer::Preview
  def mail_tickets
    # @user = params[:user]
    # @qr = QrCode.render_qr_code("https://github.com/")
    # @svg = QrCode.generate("https://github.com/")
    # attachments.inline['image.svg'] = File.read(@svg)
    @user = User.first
    TicketMailer.with(user: @user).mail_tickets
  end
end
