# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :access, Venue
      can :update, Event
      can :create, Event
    else
      can :help, Event
      can :success, Order
      can :cancel, Order
      can :read, Event
      can :create, Order
    end
  end
end
