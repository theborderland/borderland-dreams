class Responsible < ActiveRecord::Base
  belongs_to :camp
  belongs_to :person

  accepts_nested_attributes_for :person, :reject_if => :all_blank
end
