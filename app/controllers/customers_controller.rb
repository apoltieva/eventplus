class Customers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def create
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[type]).merge(type: 'Customer')
  end
end
