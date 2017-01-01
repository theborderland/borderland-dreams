class Person < ActiveRecord::Base
  has_many :responsibles
  belongs_to :camp, validate: true

  validates :name, presence: true
end
