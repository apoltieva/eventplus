# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied, with: :deny_access
  rescue_from ActiveRecord::RecordNotFound do |e|
    flash[:alert] = e.message
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def deny_access
    flash[:alert] = 'You cannot access this'
    redirect_back(fallback_location: root_path)
  end
end
