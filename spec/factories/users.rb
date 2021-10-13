# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '123456' }
    confirmed_at { Time.now }
    role { :admin }
    stripe_id { Stripe::Customer.list.data[1].id }
  end
end
