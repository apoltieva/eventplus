# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'eventplus.mailer@gmail.com'
  layout 'mailer'
end
