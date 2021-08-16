# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart!

  def new; end

  def create
    current_user.purchase_cart_products!
    flash[:notice] = 'Your tickets will be sent to your email. Thanks for your purchase!'
    TicketMailer.with(user: current_user).mail_tickets.deliver_later
    redirect_to root_url
  end

  private

  def check_cart!
    if current_user.cart_products_with_qty.blank?
      flash[:alert] = 'You need to add products before buying!'
      redirect_to root_url
    end
  end
end
