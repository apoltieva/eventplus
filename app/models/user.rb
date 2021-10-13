# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  enum role: %i[customer admin]
  has_many :orders, dependent: :destroy
  has_many :events, through: :orders

  after_create :add_stripe_id

  def add_stripe_id
    update(stripe_id: Stripe::Customer.create(email: email).id) if customer?
  end
end
