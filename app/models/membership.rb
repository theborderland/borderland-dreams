class Membership < ApplicationRecord
  belongs_to :camp
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :camp_id
end
