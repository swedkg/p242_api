class Fullfilment < ApplicationRecord
  belongs_to :request
  belongs_to :user

  validates :request_id, presence: true
  validates :user_id, presence: true
  
end