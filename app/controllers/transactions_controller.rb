# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action authenticate_user!
  before_action check_cart!

  def new; end

  def create
    current_user.purchase_cart_products!
    flash[:notice] = 'Your tickets will be sent to your email. Thanks for your purchase!'
  end
end
