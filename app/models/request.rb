class Request < ApplicationRecord
  has_many :fullfilments
  has_many :responders, through: :fullfilments, source: "user"
  belongs_to :owner, class_name: "User"

  validates :desc, presence: {message: "Your description cannot be blank"},
  length: {
    in: 3..300,
    too_short: "Your description is too short.",
    too_long: "Your description is too long (%{count} characters max).",
  }

  validates :owner, presence: true

  
end
