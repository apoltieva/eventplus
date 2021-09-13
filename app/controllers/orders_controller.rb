# frozen_string_literal: true

require 'securerandom'

class OrdersController < ApplicationController
  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:notice] = 'Your tickets will be sent to your email. Thanks for your purchase!'
      TicketMailer.with(order: @order).mail_tickets.deliver_later
    else
      flash[:alert] = @order.errors.full_messages.join('; ')
    end
    redirect_back(fallback_location: root_path)
  end

  def show
    @order = Order.find_by uuid: params[:id]
    render json: @order
  end

  private

  def order_params
    params.permit(:event_id, :quantity).merge!(uuid: SecureRandom.uuid)
  end
end
