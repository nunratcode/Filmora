class User < ApplicationRecord
  has_secure_password

  # ассоциации
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :subscriptions_as_target, class_name: "Subscription", foreign_key: "subscribed_to_id", dependent: :destroy
  has_many :subscriptions_as_subscriber, class_name: "Subscription", foreign_key: "subscriber_id", dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id", dependent: :destroy
  has_many :articles, dependent: :destroy
  has_one_attached :avatar

  # валидации
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  def avatar_url
    avatar.present? ? avatar : "/default_avatar.png"
  end

  # сброс пароля
  def generate_password_reset
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!
  end

  def full_name
    "#{profile&.first_name} #{profile&.last_name}"
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
