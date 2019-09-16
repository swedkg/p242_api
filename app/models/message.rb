class Message < ApplicationRecord
  belongs_to :fullfillment
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
end
