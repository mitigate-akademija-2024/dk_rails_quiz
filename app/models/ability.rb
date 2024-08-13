# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif user.persisted? # logged in user
      can :read, :all
      can :create, Quiz
      can [:update, :destroy], Quiz, user: user
      can :my_quizzes, Quiz
      can :do_quiz, Quiz  # All logged-in users can take any quiz
      can :submit_quiz, Quiz # All logged-in users can take any quiz
      can :result, Quiz
      can :create, Question
      can :add_answer, Question
      can :new, Question
      can :update, Question, user: user
      can :edit, Question, user: user
      can :all_high_scores, Quiz
    else # guest user
      can :read, :all
    end
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
