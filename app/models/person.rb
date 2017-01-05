class RoleKnownValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    roles = Rails.application.config_for(:roles)['available_roles'].map(&:to_s)
    attempt = value.map(&:to_s)
    unknown = (Set.new(attempt) ^ roles) - roles
    record.errors.add(attribute, 'is not included in the list') if unknown.any?
  end
end

class Person < ActiveRecord::Base
  belongs_to :camp, validate: true
  serialize :roles, Array

  validates :name, presence: true
  validates :roles, role_known: true, allow_nil: true

  def active_roles
    wrap_roles(roles)
  end

  def self.wrap_roles(l)
    l.map { |r|
      OpenStruct.new(t: r, id: r)
    }
  end
end
