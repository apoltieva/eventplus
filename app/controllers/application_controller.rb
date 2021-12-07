# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  rescue_from CanCan::AccessDenied, with: :deny_access
  rescue_from ActiveRecord::RecordNotFound do |e|
    flash[:alert] = e.message
    render json: { error: e.message }, status: :unprocessable_entity
  end

  protected

  def set_i18n_locale_from_params
    return unless params[:locale]

    if I18n.available_locales.map(&:to_s).include?(params[:locale])
      I18n.locale = params[:locale]
    else
      flash.now[:notice] = "#{params[:locale]} translation not available"
      logger.error flash.now[:notice]
    end
  end

  private

  def deny_access
    flash[:alert] = 'You cannot access this'
    redirect_back(fallback_location: root_path)
  end
end
