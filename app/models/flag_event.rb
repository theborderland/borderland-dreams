class FlagEvent < ApplicationRecord
  belongs_to :flag_definition
  belongs_to :user
  belongs_to :camp
end