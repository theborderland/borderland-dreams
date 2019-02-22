class ImagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :enforce_permission!, only: [:create, :destroy, :archive]
  before_filter :camp_id

  # TODO: You'll likely want to load up the camp here, so that
  # if you need to put in permissions later you can
  # before_filter :load_camp, only: :index
  # def load_camp
  #   @camp = Camp.find_by(id: params[:camp_id]) # <- later, ensure the current user can view this camp
  # end
  # then, in the view, just @camp.images will do
  def index
    @images = Image.where(camp_id: @camp_id)
  end

  # TODO: this method doesn't appear to be used?
  def show
    image = Image.find_by_id(params[:id])
  end

  # TODO: redirect is likely slightly cleaner in a before action
  # before_action :enforce_attachment
  # def enforce_attachment
  #   return if params[:attachment]
  #   redirect_to camp_images_path(params.slice(:camp_id)), flash: { alert: t(:error_no_image_selected) }
  # end
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
    # TODO: you should prefer Image.find over Image.find_by_id :)
    @image = Image.find_by_id(params[:id])
    # TODO: Paperclip _should_ do this for you automatically,
    @image.attachment = nil
    @image.save!
    @image.destroy!

    redirect_to camp_images_path(camp_id: @camp_id)
  end

  def enforce_permission!
    @camp = Camp.find(camp_id)

    if (@camp.creator != current_user) and (!current_user.admin)
      flash[:alert] = "#{t:security_cant_change_images_you_dont_own}"
      redirect_to camp_images_path(camp_id: camp_id)
    end
  end

  def camp_id
    @camp_id = params[:camp_id]
  end

  private

  def image_params
    params.permit(:attachment, :camp_id)
  end
end
