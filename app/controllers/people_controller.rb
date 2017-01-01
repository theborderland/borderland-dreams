class PeopleController < ApplicationController
  before_action :authenticate_user!, :load_camp!

  def show
    @person = @camp.people.find(params[:id])
    render json: @person
  end

  def update
    @person = @camp.people.find(params[:id])
    @person.update!(params.require(:person).permit!)
    render json: @person
  end

  private

  def load_camp!
    @camp = Camp.find(params[:camp_id])
    if (@camp.creator != current_user) and (!current_user.admin)
      flash[:alert] = "#{t:security_cant_edit_dreams_you_dont_own}"
      redirect_to camp_path(@camp)
    end
  end
end
