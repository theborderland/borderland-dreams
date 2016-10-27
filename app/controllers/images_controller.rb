class ImagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_filter :camp_id

  def index
    @images = Image.where(camp_id: @camp_id)
  end

  def show
    image = Image.find_by_id(params[:id])
    #send_data image.image, disposition: :inline
  end

  def create
    if params[:attachment].blank?
      flash[:alert] = t(:error_no_image_selected)
      redirect_to camp_images_path(camp_id: @camp_id)
      return
    end
    @image = Image.new(image_params)
    @image.user_id = current_user.id

    if @image.save
      redirect_to camp_images_path(camp_id: @camp_id)
    else
      render action: 'index'
    end
  end

  def destroy
    @image = Image.find_by_id(params[:id])
    @image.attachment = nil
    @image.save!
    @image.destroy!

    redirect_to camp_images_path(camp_id: @camp_id)
  end

  def camp_id
    @camp_id = params[:camp_id]
  end

  private

  def image_params
    params.permit(:attachment, :camp_id)
  end
end
