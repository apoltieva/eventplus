# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied, with: :deny_access

  private

  def deny_access
    flash[:alert] = 'You cannot access this'
    redirect_back(fallback_location: root_path)
  end
end
