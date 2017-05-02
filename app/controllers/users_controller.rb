class UsersController < ApplicationController
  before_action :authenticate_user!
  after_initialize :add_product

  def me
    @grants = Grant.where(user_id: current_user.id).find_each
    @my_dreams = current_user.created_camps
    @memberships = current_user.created_camps.joins(:memberships).joins(:users)
                       .where('users.id != ?', current_user.id).select('users.email')

    respond_to do |format|
      format.html
      format.js
    end
  end

  def get_grants
    self.grants ||= 10 if self.has_ticket?
  end

end




