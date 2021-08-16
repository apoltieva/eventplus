# frozen_string_literal: true

class OrdersController < ApplicationController

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:notice] = 'Your tickets will be sent to your email. Thanks for your purchase!'
      TicketMailer.with(user: current_user).mail_tickets.deliver_later
      redirect_to events_path
    else
      flash[:alert] = @event.errors.full_messages.join("; ")
    end
  end

  private
  def order_params
    params.permit(:event_id, :user_id, :quantity)
  end
end
