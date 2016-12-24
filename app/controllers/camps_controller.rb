class CampsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    filter = params[:filterrific] || {}
    filter[:only_active] = true
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
    build_peoples_for(@camp)
  end

  def edit
    @camp = Camp.find params[:id]
    # build_peoples_for(@camp)
  end

  def build_peoples_for(camp)
    add_responsible('projectManager')
    # camp.build_vice_project_manager
    # camp.build_daily_inspection_responsible
    # camp.build_disassembly_responsible
    # camp.build_lnt_respomsible
    # camp.build_funding_
  end

  # Add responsible
  def add_responsible(responsibility_type)
    # @camp = Camp.find(params[:id])
    # params[:user] ? @user = User.find(params[:user]) : @user = nil

    # CHECK IF all positions exists
    @person = Person.create(name: "David", email: "test@gmail.com", phone_number:'00000',responsibility_type: 'Project Manager')
    @camp.people << @person
    #
    # Only add a user to the list of associated members if the user isn't
    # in the list. We should add a uniqueness validation to this.
    #

    # if !@user
    #   flash[:notice] = "#{t:join_dream}"
    # elsif @camp.users.include?(@user)
    #   flash[:notice] = "#{t:join_already_sent}"
    # else
    #   flash[:notice] = "#{t:join_dream}"
    #   @camp.users << @user
    # end
    # redirect_to @camp
  end

  def create
    @camp = Camp.new(camp_params)
    @camp.creator = current_user

    if @camp.save
      flash[:notice] = t('created_new_dream')
      redirect_to edit_camp_path(id: @camp.id)
    else
      flash.now[:notice] = "#{t:errors_str}: #{@camp.errors.full_messages.join(', ')}"
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
    if(granted <= 0)
      flash[:alert] = "#{t:cant_send_less_then_one}"
      redirect_to camp_path(@camp) and return
    end

    if @camp.maxbudget.nil?
      flash[:alert] = "#{t:dream_need_to_have_max_budget}"
      redirect_to camp_path(@camp) and return
    end

    if @camp.grants_received + granted > @camp.maxbudget
        granted = @camp.maxbudget - @camp.grants_received
    end

    if current_user.grants < granted
      flash[:alert] = "#{t:security_more_grants, granted: granted, current_user_grants: current_user.grants}"
      redirect_to camp_path(@camp) and return
    end

    ActiveRecord::Base.transaction do
      current_user.grants -= granted

      # Increase camp grants.
      @camp.grants.new({:user_id => current_user.id, :amount => granted})      

      if @camp.grants_received + granted >= @camp.minbudget
        @camp.minfunded = true
      else
        @camp.minfunded = false
      end
      
      if @camp.grants_received + granted >= @camp.maxbudget
        @camp.fullyfunded = true
      else
        @camp.fullyfunded = false
      end
        
      unless current_user.save
        flash[:notice] = "#{t:errors_str}: #{current_user.errors.full_messages.join(', ')}"
        redirect_to camp_path(@camp) and return
      end
      
      unless @camp.save
        flash[:notice] = "#{t:errors_str}: #{@camp.errors.full_messages.join(', ')}"
        redirect_to camp_path(@camp) and return
      end
    end

    redirect_to camp_path(@camp)
    flash[:notice] = "#{t:thanks_for_sending, grants: granted}"
  end

  def update
    @camp = Camp.find(params[:id])
    if (@camp.creator != current_user) and (!current_user.admin)
      flash[:alert] = "#{t:security_cant_edit_dreams_you_dont_own}"
      redirect_to camp_path(@camp) and return
    end

    # I'm not sure this is the right way to do this, but...
    camp_params['responsibles_attributes'].each { |_, v|
      v['person_attributes']['camp_id'] = @camp.id if v['person_attributes'].is_a?(Hash)
    }
    if @camp.update_attributes camp_params
      if params[:done] == '1'
        redirect_to camp_path(@camp)
      else
        redirect_to edit_camp_path(id: @camp.id)
      end
    else
      flash.now[:notice] = "#{t:errors_str}: #{@camp.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  def destroy
    @camp = Camp.find(params[:id])
    if (@camp.creator != current_user) and (!current_user.admin)
      flash[:alert] = "#{t:security_cant_delete_dreams_you_dont_own}"
      redirect_to camp_path(@camp) and return
    end

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
      flash[:notice] = "#{t:join_dream}"
    elsif @camp.users.include?(@user)
      flash[:notice] = "#{t:join_already_sent}"
    else
      flash[:notice] = "#{t:join_dream}"
      @camp.users << @user
    end
    redirect_to @camp
  end

  private

  def camp_params
    params.require(:camp).permit!
  end

end
