# frozen_string_literal: true

class QrCode
  def self.generate(url)
    IO.binwrite('/tmp/ticket-qrcode.png', RQRCode::QRCode.new(url).as_png(size: 400).to_s)
    '/tmp/ticket-qrcode.png'
  end
end
