class Request < ApplicationRecord
  has_many :fullfillments
  belongs_to :owner, class_name: "User"
end
