# frozen_string_literal: true

class QrCodeGenerator
  def self.call(url)
    file_path = "/tmp/ticket-#{url.split('/')[-1]}-qrcode.png"
    IO.binwrite(file_path, RQRCode::QRCode.new(url).as_png(size: 400).to_s)
    file_path
  end
end
