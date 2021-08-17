# frozen_string_literal: true

class QrCode

  def self.generate(url)
    RQRCode::QRCode.new(url).as_svg(use_path: true, offset: 100)
  end

end
