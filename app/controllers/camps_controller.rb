class CampsController < ApplicationController
  include CanApplyFilters
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_camp!, except: [:index, :new, :create]
  before_action :load_lang_detector, only: [:show, :index]

  # TODO: Check out howcanihelp_controller for a suggestion on refactoring this method
  def index
    filter = params[:filterrific] || { sorted_by: 'updated_at_desc' }
    filter[:active] = true
    filter[:not_hidden] = true

    if (!current_user.nil? && (current_user.admin? || current_user.guide?))
      filter[:hidden] = true
      filter[:not_hidden] = false
    end

    @filterrific = initialize_filterrific(
      Camp,
      filter
    ) or return
    @camps = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @camp = Camp.new
  end

  def edit
    @just_view = params[:just_view]
  end

  def create
    @camp = Camp.new(camp_params.merge(creator: current_user))

    if create_camp
      flash[:notice] = t('created_new_dream')
      redirect_to edit_camp_path(id: @camp.id)
    else
      flash.now[:notice] = "#{t:errors_str}: #{@camp.errors.full_messages.uniq.join(', ')}"
      render :new
    end
  end

  # Toggle granting

  def toggle_granting
    @camp.toggle!(:grantingtoggle)
    redirect_to camp_path(@camp)
  end

  # Handle the grant updates in their own controller action
  def update_grants
    # Reduce the number of grants assigned to the current user by the number
    # of grants given away. Increase the number of grants assigned to the
    # camp by the same number of grants.
    @grants_received = current_user.grants.where(camp: @camp).sum(:amount)
    granted = [
      params[:grants].to_i,
      @camp.maxbudget - @camp.grants_received
    ].min

    assert(@camp.maxbudget.present? :dream_need_to_have_max_budget)
    assert(granted > 0, :cant_send_less_then_one)
    assert(current_user.grants >= granted, :security_more_grants, granted: granted, current_user_grants: current_user.grants)
    assert(
      @grants_received + granted < Grant.max_per_user_per_dream || current_user.admin,
      :exceeds_max_grants_per_user_for_this_dream,
      max_grants_per_user_per_dream: Grant.max_per_user_per_dream
    )

    ActiveRecord::Base.transaction do
      current_user.update!(grants: current_user.grants - granted)
      @camp.grants.build(user: current_user, amount: granted)
      @camp.assign_attributes(
        minfunded:   (@camp.grants_received + granted) >= @camp.minbudget,
        fullyfunded: (@camp.grants_received + granted) >= @camp.maxbudget
      )
      assert(@camp.save, :errors_str, message: @camp.errors.full_messages.uniq.join(', '))
    end

    flash[:notice] = t(:thanks_for_sending, grants: granted)
    redirect_to camp_path(@camp)
  end

  def update
    assert(@camp.creator == current_user || current_user.admin || current_user.guide, :security_cant_edit_dreams_you_dont_own)

    if @camp.update_attributes camp_params
      if params[:done] == '1'
        redirect_to camp_path(@camp)
      else
        respond_to do |format|
          format.html { redirect_to edit_camp_path(@camp) }
          format.json { respond_with_bip(@camp) }
        end
      end
    else
      flash.now[:alert] = t(:errors_str, message: @camp.errors.full_messages.uniq.join(', '))
      respond_to do |format|
        format.html { render action: :edit }
        format.json { respond_with_bip(@camp) }
      end
    end
  end

  def tag
    assert(current_user.admin || current_user.guide, :security_cant_tag_dreams_you_dont_own)
    @camp.update_attributes(tag_list: params.require(:camp).require(:tag_list))

    flash[:notice] = t(:tags_saved)
    redirect_to camp_path(@camp)
  end

  def destroy
    assert(current_user == @camp.owner || current_user.admin, :security_cant_delete_dreams_you_dont_own)
    @camp.destroy!
    redirect_to camps_path
  end

  # Display a camp and its users
  def show
  end

  # Allow a user to join a particular camp.
  def join
    if !current_user
      flash[:notice] = t(:join_dream)
    elsif @camp.users.include?(current_user)
      flash[:notice] = t(:join_already_sent)
    else
      flash[:notice] = t(:join_dream)
      @camp.users << @user
    end
    redirect_to @camp
  end

  def archive
    assert(current_user == @camp.owner || current_user.admin, :security_cant_delete_dreams_you_dont_own)
    @camp.update!(active: false)
    redirect_to camps_path
  end

  private

  # TODO: We can't permit! attributes like this, because it means that anyone
  # can update anything about a camp in any way (including the id, etc); recipe for disaster!
  # we'll have to go through and determine which attributes can actually be updated via
  # this endpoint and pass them to permit normally.
  def camp_params
    params.require(:camp).permit!
  end

  def load_camp!
    return if @camp = Camp.find_by(params.permit(:id))
    flash[:alert] = t(:dream_not_found)
    redirect_to camps_path
  end

  def failure_path
    camp_path(@camp)
  end

  def create_camp
    Camp.transaction do
      @camp.save!
      if Rails.application.config.x.firestarter_settings['google_drive_integration'] and ENV['GOOGLE_APPS_SCRIPT'].present?
        response = NewDreamAppsScript::createNewDreamFolder(@camp.creator.email, @camp.id, @camp.name)
        @camp.google_drive_folder_path = response['id']
        @camp.google_drive_budget_file_path = response['budget']
        @camp.save!
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def load_lang_detector
    @detector = StringDirection::Detector.new(:dominant)
  end
end
