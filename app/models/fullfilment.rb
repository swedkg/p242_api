class Fullfilment < ApplicationRecord
  belongs_to :request
  belongs_to :user

  #TODO: ADD validations here!!
  # TODO: test all models and controllers!!

  validates :request_id, presence: true
  validates :user_id, presence: true
  
end