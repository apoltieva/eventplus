# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  enum role: %i[customer admin]
  has_many :orders, dependent: :destroy
  has_many :events, through: :orders
end
