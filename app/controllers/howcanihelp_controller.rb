class HowcanihelpController < ApplicationController
  # TODO: here's a stab at a refactor of this method:
  # def index
  #   hidden = current_user&.admin? || current_user&.guide?
  #   @filterrific = initialize_filterrific(Camp, params[:filterrific].merge(
  #     is_cocreation: true,
  #     active: true,
  #     hidden: hidden,
  #     not_hidden: !hidden <- Do you really need this one?
  #   )
  #   @camps = @filteriffic.find.page(params[:page])
  # end
  def index
    filter = params[:filterrific] || { sorted_by: 'updated_at_desc' }
    filter[:active] = true
    filter[:not_hidden] = true
    filter[:is_cocreation] = true
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

end
