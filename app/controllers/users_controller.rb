class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
  	puts current_user.id

  	@grants = Grant.where(user_id: current_user.id).find_each
  	@my_dream = Camp.find_by creator: current_user.id

    respond_to do |format|
      format.html
      format.js
    end
  end

end