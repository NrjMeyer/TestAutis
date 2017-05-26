class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user && user.admin?
      can :access, :rails_admin
      can :dashboard
      if user.admintype == "superadmin"
        can :manage, :all
      else
        can :index, :all
      end
    end
  end
end
