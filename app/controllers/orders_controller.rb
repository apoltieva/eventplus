# frozen_string_literal: true

class OrdersController < ApplicationController

  def new
    @order = current_user.orders.build(order_params)
  end

  def create
    @order = current_user.orders.build(order_params)
    p '-------------------'
    p @order
    p '-------------------'
    session = Stripe::Checkout::Session
              .create({
                        payment_method_types: ['card'],
                        line_items: [{
                          price_data: {
                            currency: 'usd',
                            product_data: {
                              name: @order.event.title
                            },
                            unit_amount: @order.event.ticket_price,
                          },
                          quantity: @order.quantity
                        }],
                        mode: 'payment',
                        success_url: 'https://example.com/success',
                        cancel_url: 'https://example.com/cancel'
                      })

    redirect_to session.url
    # @order = current_user.orders.build(order_params)
    # if @order.save
    #   flash[:notice] = 'Your tickets will be sent to your email. Thanks for your purchase!'
    #   TicketSender.send_tickets_for @order
    # else
    #   flash[:alert] = @order.errors.full_messages.join('; ')
    # end
    # redirect_back(fallback_location: root_path)
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
