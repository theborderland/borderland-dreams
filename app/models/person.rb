class Person < ActiveRecord::Base
  belongs_to :camp, validate: true
  has_and_belongs_to_many :roles

  validates :name, presence: true

  schema_validations whitelist: [:id, :created_at, :updated_at, :camp]

  scope :in_camp, -> { joins(:camp) }
end
