class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :fullfilments
  has_many :messages
  has_many :requests, class_name: "Request", foreign_key: "owner_id"
end
