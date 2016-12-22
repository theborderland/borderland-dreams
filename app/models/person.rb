class Person < ActiveRecord::Base
  has_many :responsibles
  has_many :camps, through: :responsibles
end