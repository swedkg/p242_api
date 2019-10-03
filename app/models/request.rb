class Request < ApplicationRecord
  has_many :fullfilments
  belongs_to :owner, class_name: "User"
end
