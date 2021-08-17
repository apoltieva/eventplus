# frozen_string_literal: true

class QrCode
  def self.generate(url)
    file_path = "/tmp/ticket-#{url}-qrcode.png"
    unless File.exist? file_path
      IO.binwrite(file_path, RQRCode::QRCode.new(url).as_png(size: 400).to_s)
    end
    file_path
  end
end
