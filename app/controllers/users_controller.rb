class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_lang_detector, only: [:show, :index, :me]

  def show
    @memberships = current_user.created_camps.joins(:memberships).joins(:users)
                       .where('users.id != ?', current_user.id).select('users.email')
    @user = User.find(params[:id])
  end

  def load_lang_detector
    @detector = StringDirection::Detector.new(:dominant)
  end
end
