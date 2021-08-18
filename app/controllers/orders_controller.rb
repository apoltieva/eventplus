# frozen_string_literal: true

require 'securerandom'

class OrdersController < ApplicationController
  def create
    @order = current_user.orders.build(order_params)
    @order.uuid = SecureRandom.uuid
    if @order.save
      flash[:notice] = 'Your tickets will be sent to your email. Thanks for your purchase!'
      TicketMailer.with(user: current_user, event: @order.event,
                        uuid: @order.uuid).mail_tickets.deliver_later
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @event.errors.full_messages.join('; ')
    end
  end

  def show
    @order = Order.find_by uuid: params[:id]
    render json: @order
  end

  private

  def order_params
    params.permit(:event_id, :quantity)
  end
end
