class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  # validates_presence_of :phone
  # validates_presence_of :first_name
  # validates_presence_of :last_name
  validates_uniqueness_of :phone
  validates_uniqueness_of :email

  has_many :posts
  # has_and_belongs_to_many :networks
  has_many :networks_users
  has_many :networks, through: :networks_users

  #
  has_many :deleted_messages
  has_many :messages_deleted, through: :deleted_messages, class_name: 'Message'

  has_many :user_likes
  has_many :liked_messages, through: :user_likes, class_name: 'Message'

  has_many :providers, dependent: :destroy

  before_create :generate_authentication_token!

  has_attached_file :avatar, styles: { medium: "256x256#", thumb: "100x100>" }, default_url: "/images/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def connected_networks
    providers.pluck(:name)
  end

  def avatar_url
    avatar.url(:medium)
  end
end
