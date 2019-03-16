class Grant < ActiveRecord::Base
  include AppSettings
  belongs_to :user
  belongs_to :camp

  # This wants to be
  # def self.max_per_user_per_dream, etc.
  def self.max_per_user_per_dream
    return app_setting('max_grants_per_user_per_dream')
  end

  def self.value_for_currency
    return app_setting('grant_value_for_currency')
  end

end
