class Request < ApplicationRecord
  has_many :fullfilments
  has_many :responders, through: :fullfilments, source: "user"
  belongs_to :owner, class_name: "User"
end
