# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
  
    can :read, :home 

    return unless user.present?

    can :manage, :all if user.is_admin?

    if user.is_manager? 
      # can :read, Transaction
      can :read, :cleaning_predictor
      can :read, :linen_counter
      
      can :index, :deposit
      can :read, :deposits

      can :show, Booking
    end 
  


    

  end
end
