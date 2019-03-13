class PeopleController < ApplicationController
  before_action :authenticate_user!, :load_camp!

  def show
    render json: @camp.people.find(params[:id])
  end

  def update
    @person = @camp.people.find(params[:id])
    @person.update!(people_params)
    render json: @person
  end

  private

  def load_camp!
    @camp = Camp.find(params[:camp_id])
    assert(@camp.creator == current_user || current_user.admin, :security_cant_edit_dreams_you_dont_own)
  end

  def failure_path
    camp_path(@camp)
  end

  def people_params
    params.require(:person).permit(
      :name, :email, :phone_number, :background,
      :camp_id, :has_ticket, :needs_early_arrival
    )
  end
end
