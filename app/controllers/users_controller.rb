class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    @memberships = current_user.created_camps.joins(:memberships).joins(:users)
                       .where('users.id != ?', current_user.id).select('users.email')
  end
end
