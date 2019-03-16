class Grant < ApplicationRecord
  include AppSettings
  belongs_to :user
  belongs_to :camp
end
