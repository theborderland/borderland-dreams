class FlagEvent < ApplicationRecord
  belongs_to :user
  belongs_to :camp

  def self.distinct_types
    self.distinct.pluck(:flag_type)
  end
end