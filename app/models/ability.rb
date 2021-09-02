# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :access, Venue
      can :update, Event
    else
      can :read, Event
      can :create, Order
    end
  end
end
