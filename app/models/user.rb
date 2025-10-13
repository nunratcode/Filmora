# app/models/user.rb
class User < ApplicationRecord

  has_secure_password

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :subscriptions_as_target, class_name: 'Subscription', foreign_key: 'subscribed_to_id', dependent: :destroy

  has_many :subscriptions_as_subscriber, class_name: 'Subscription', foreign_key: 'subscriber_id', dependent: :destroy

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id', dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def full_name
    "#{profile&.first_name} #{profile&.last_name}"
  end
end