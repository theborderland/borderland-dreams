class Grant < ActiveRecord::Base
  include AppSettings
  belongs_to :user
  belongs_to :camp
end
