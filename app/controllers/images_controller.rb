class ImagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_camp!

  def index
  end

  def create
    assert(params[:attachment], :error_no_image_selected)
    @image = Image.new(image_params)

    if @image.save
      redirect_to camp_images_path(params.slice(:camp_id))
    else
      render action: :index
    end
  end

  def destroy
    Image.find(params[:id]).destroy!
    redirect_to camp_images_path(params.slice(:camp_id))
  end

  private

  def load_camp!
    @camp = Camp.find(params[:camp_id])
    assert(current_user == @camp.creator || current_user.admin, :security_cant_change_images_you_dont_own)
  end

  def failure_path
    camp_images_path(@camp)
  end

  def image_params
    params.permit(:attachment, :camp_id).merge(user: current_user)
  end
end
