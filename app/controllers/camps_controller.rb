class CampsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @filterrific = initialize_filterrific(
      Camp,
      params[:filterrific]
    ) or return
    @camps = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @camp = Camp.new
    @submit_text = 'Create'
  end

  def edit
    @camp = Camp.find params[:id]
    @submit_text = 'Update'
  end

  def create
    @camp = Camp.new(camp_params)
    @camp.creator = current_user

    if @camp.save
      redirect_to camps_path
    else
      flash.now[:notice] = "Errors: #{@camp.errors.full_messages.join(', ')}"
      render :new
    end
  end

  # Toggle granting

  def toggle_granting
    @camp = Camp.find(params[:id])
    @camp.toggle!(:grantingtoggle)
    redirect_to camp_path(@camp)
  end

  # Handle the grant updates in their own controller action
  def update_grants
    @camp = Camp.find(params[:id])

    # Reduce the number of grants assigned to the current user by the number
    # of grants given away. Increase the number of grants assigned to the
    # camp by the same number of grants.

    # Decrement user grants. Check first if granting more than needed.
    granted = params['grants'].to_i
    if @camp.grants_received + granted > @camp.maxbudget
      granted = @camp.maxbudget - @camp.grants_received
    end

    if current_user.grants < granted
      flash[:alert] = "Security error cannot grant more then available grants #{granted} / #{current_user.grants}"
      redirect_to camp_path(@camp) and return
    end

    current_user.grants -= granted

    # Increase camp grants.
    @camp.grants_received += granted

    if @camp.grants_received >= @camp.minbudget
      @camp.minfunded = true
    else
      @camp.minfunded = false
    end

    if @camp.grants_received >= @camp.maxbudget
      @camp.fullyfunded = true
    else
      @camp.fullyfunded = false
    end

    unless current_user.save
      flash[:notice] = "Errors: #{current_user.errors.full_messages.join(', ')}"
      redirect_to camp_path(@camp) and return
    end

    unless @camp.save
      flash[:notice] = "Errors: #{@camp.errors.full_messages.join(', ')}"
      redirect_to camp_path(@camp) and return
    end

    redirect_to camp_path(@camp)
    flash[:notice] = "Thanks for sending #{granted} grant(s)"
  end

  def update
    @camp = Camp.find(params[:id])

    if @camp.update_attributes camp_params
      redirect_to camp_path(@camp)
    else
      flash.now[:notice] = "Errors: #{@camp.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  def destroy
    @camp = Camp.find(params[:id])
    @camp.destroy!

    redirect_to camps_path
  end

  # Display a camp and its users
  def show
    @camp = Camp.find(params[:id])
    @users = @camp.users

    # Added this to move some code out of the view.
    if current_user
      @user_grant_limit = current_user.grants
    end
  end

  # Allow a user to join a particular camp.
  def join
    @camp = Camp.find(params[:id])

    params[:user] ? @user = User.find(params[:user]) : @user = nil

    #
    # Only add a user to the list of associated members if the user isn't
    # in the list. We should add a uniqueness validation to this.
    #

    if !@user
      flash[:notice] = "You need to be logged in to add your email to the list."
    elsif @camp.users.include?(@user)
      flash[:notice] = "Nice! You've already sent your email to the creator."
    else
      flash[:notice] = "Sweet! You just sent your email adress to the creator."
      @camp.users << @user
    end
    redirect_to @camp
  end

  private

  def camp_params
    params.require(:camp).permit!
  end

end
