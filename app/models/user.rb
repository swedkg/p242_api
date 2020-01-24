class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :picture

  has_many :fullfilments
  has_many :responded_requests, through: :fullfilments, source: "request"
  has_many :messages
  has_many :requests, class_name: "Request", foreign_key: "owner_id"

  # TODO: password?

  validates :firstName, presence: {message: "Your first name cannot be blank"}, length: {
    in: 3..20,
    too_short: "Your first name is too short.",
    too_long: "Your first name is too long (%{count} characters max).",
  }

  validates :lastName, presence: {message: "Your last name cannot be blank"}, length: {
    in: 3..40,
    too_short: "Your last name is too short.",
    too_long: "Your last name is too long (%{count} characters max).",
  }
  
  validates :email, uniqueness: {message: "This email is already in use"}
  validates :email, presence: {message: "The email is required"}
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "The email is invalid",
  }


end
