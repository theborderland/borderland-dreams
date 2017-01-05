class DefaultRoles < ActiveRecord::Migration
  def change
    Rails.application.config_for(:roles)['available_roles'].each do |r|
      Role.create!(identifier: r)
    end
  end
end
