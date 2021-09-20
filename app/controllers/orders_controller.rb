# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:notice] = 'Your tickets will be sent to your email. Thanks for your purchase!'
      TicketSender.send_tickets_for @order
    else
      flash[:alert] = @order.errors.full_messages.join('; ')
    end
    redirect_back(fallback_location: root_path)
  end

  def show
    @order = Order.find_by uuid: params[:id]
    if @order
      render json: @order
    else
      render json: { error: 'No order with such uuid' }, status: :not_found
    end
  end

  private

  def order_params
    params.require(:order).permit(:event_id, :quantity)
  end
end
