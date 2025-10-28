class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: 'user')

    case user.role
    when 'admin'
      can :manage, :all 
    when 'creator'
      can :read, :all
      can :create, Article
      can :update, Article, user_id: user.id
    when 'user'
      can :read, :all
      can :create, Post
      can :update, Post, user_id: user.id
      can :destroy, Post, user_id: user.id

      can :create, Comment
      can :update, Comment, user_id: user.id
      can :destroy, Comment, user_id: user.id

      can :create, Like
      can :destroy, Like, user_id: user.id

      can :create, Favorite
      can :destroy, Favorite, user_id: user.id

      can :create, Subscription
      can :destroy, Subscription, subscriber_id: user.id

      can :read, Message, recipient_id: user.id
      can :read, Message, sender_id: user.id
      can :create, Message
      can :destroy, Message, sender_id: user.id
    end
  end
end