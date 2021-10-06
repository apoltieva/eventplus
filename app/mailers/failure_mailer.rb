class FailureMailer < ApplicationMailer
  def inform_about_checkout_failure
    @customer = params[:customer]
    mail(to: @customer.email, subject: 'Something went wrong during your Event+ order checkout')
  end
end
