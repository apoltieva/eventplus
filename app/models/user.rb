# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  enum role: %i[customer admin]
  has_many :orders
  has_many :events, through: :orders

  def current_user_cart
    "cart#{id}"
  end

  def add_to_cart(event_id)
    $redis.hincrby current_user_cart, event_id, 1
  end

  def remove_from_cart(event_id)
    $redis.hdel current_user_cart, event_id
  end

  def remove_one_from_cart(event_id)
    $redis.hincrby current_user_cart, event_id, -1
  end

  def cart_count
    quantities = $redis.hvals "cart#{id}"
    quantities.reduce(0) { |sum, qty| sum += qty.to_i }
  end

  def cart_total_price
    get_cart_products_with_qty.map { |event, qty| event.ticket_price * qty.to_i }.reduce(:+)
  end

  def get_cart_products_with_qty
    cart_ids = []
    cart_qtys = []
    ($redis.hgetall current_user_cart).map do |key, value|
      cart_ids << key
      cart_qtys << value
    end
    cart_products = Event.find(cart_ids)
    cart_products.zip(cart_qtys)
  end

  def purchase_cart_products!
    get_cart_products_with_qty do |event, qty|
      orders.create(user: self, event: event, quantity: qty)
    end
    $redis.del current_user_cart
  end
end
