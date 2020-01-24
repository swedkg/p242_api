class Message < ApplicationRecord
  belongs_to :fullfilment
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :message, presence: {message: "Your message cannot be blank"}, length: {
    in: 3..150,
    too_short: "Your message is too short.",
    too_long: "Your message is too long (%{count} characters max).",
  }

end
