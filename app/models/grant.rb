class Grant < ActiveRecord::Base
  belongs_to :user
  belongs_to :camp

  # This wants to be
  # def self.max_per_user_per_dream, etc.
  def self.max_per_user_per_dream
    return Rails.configuration.x.firestarter_settings['max_grants_per_user_per_dream']
  end

  def self.value_for_currency
    return Rails.configuration.x.firestarter_settings['grant_value_for_currency']
  end

end
