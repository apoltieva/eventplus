# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'eventplus.mailer@gmail.com'
  layout 'mailer'

  def welcome
    mail(to: 'poltyeva.anna@gmail.com', subject: 'Welcome to my App')
  end
end
