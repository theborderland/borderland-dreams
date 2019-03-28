class FlagDefinition < ApplicationRecord
  validates :name, uniqueness: true
end
