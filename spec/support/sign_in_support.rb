# frozen_string_literal: true

module ValidUserRequestHelper
  include Warden::Test::Helpers

  # for use in request specs
  def sign_in_as_a_valid_user
    @user ||= create :user
    login_as @user
  end

  def sign_in_as_a_valid_customer
    @user ||= create(:user, role: 0)
    login_as @user
  end
end
