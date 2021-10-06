# frozen_string_literal: true

class Customer < User
  after_create :add_stripe_id
  def add_stripe_id
    update(stripe_id: Stripe::Customer.create(email: email).id)
  end
end
