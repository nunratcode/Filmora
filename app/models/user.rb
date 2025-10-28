class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Ассоциации
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :subscriptions_as_target, class_name: 'Subscription', foreign_key: 'subscribed_to_id', dependent: :destroy
  has_many :subscriptions_as_subscriber, class_name: 'Subscription', foreign_key: 'subscriber_id', dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id', dependent: :destroy
  has_many :articles, dependent: :destroy

  # Валидации
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Роли
  enum role: { user: 0, creator: 1, admin: 2 }

  # Методы
  def full_name
    "#{profile&.first_name} #{profile&.last_name}"
  end
end