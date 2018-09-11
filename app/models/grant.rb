class Grant < ActiveRecord::Base
  belongs_to :user
  belongs_to :camp

  def Grant.max_per_user_per_dream
    return Rails.configuration.x.firestarter_settings['max_grants_per_user_per_dream']
  end

  def Grant.value_for_currency
    return Rails.configuration.x.firestarter_settings['grant_value_for_currency']
  end

  def Grant.received_for_camp_by_user(camp_id, user_id)
    return self.where(camp_id: camp_id, user_id: user_id).sum(:amount)
  end

end
