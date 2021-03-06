class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # permissions for admins
    if user.role? :admin
      can [:read, :show, :edit, :update, :deactivate], :all
      can [:create, :requests, :pause, :update_pause], Mentor 
      can [:create, :matches, :pause, :update_pause], Mentee
      can :create, Mentorship
      can :manage, User 

    elsif user.role?(:contributor) && user.active
      can [:index, :about, :contact, :privacy], :home
      can [:show, :setup, :profile, :edit, :update, :new, :change_password, :update_user, :account, :signup], User do |u|
        u.id == user.id
      end
      
      can [:show, :update, :destroy], Mentorship do |mentorship|
        mentor = Mentor.find(mentorship.mentor_id) 
        mentee = Mentee.find(mentorship.mentee_id)
        user.id == mentor.user_id || user.id == mentee.user_id 
      end
      
      can [:index], Mentorship
      
      if !user.is_mentor?
        can :create, Mentor
      end 
      
      if !user.is_mentee?
        can :create, Mentee 
      end 
        
      if user.is_mentor? 
        can [:requests], Mentor
        can [:show, :update, :destroy, :pause, :update_pause, :edit], Mentor do |mentor|
          mentor.user_id == user.id
        end
        can [:show], Mentee do |mentee| 
          mentor = Mentor.for_user(user.id).first
          mentee_ids = Mentorship.for_mentor(mentor).all.map { |mentorship| mentorship.mentee_id } 
          mentee_ids.include? mentee.id
        end 
      end 
      
      if user.is_mentee? 
        can [:matches], Mentee
        can [:show, :update, :destroy, :pause, :update_pause, :edit], Mentee do |mentee|
          mentee.user_id == user.id
        end
        can [:show], Mentor do |mentor| 
          mentee = Mentee.for_user(user.id).first
          mentee.get_matches.each do |m|
            m[0] == mentor 
          end 
        end
        can :create, Mentorship
      end

    else 
      can [:index, :about, :contact, :privacy], :home
      can [:show], User do |u|
        u.id == user.id
      end
      can [:signup, :new, :profile, :update, :setup], User
    end
  end
end
