# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :event
    association :user
    quantity { rand 1...10 }
  end
end
