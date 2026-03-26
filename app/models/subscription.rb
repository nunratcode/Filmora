class Subscription
  include ActiveModel::Model

  attr_accessor :subscription_type, :for_whom, :duration
  validates :subscription_type, :for_whom, :duration, presence: true
end
