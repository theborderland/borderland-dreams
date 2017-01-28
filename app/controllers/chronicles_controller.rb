class ChroniclesController < ApplicationController
  def index
    filter = params[:filterrific] || { sorted_by: 'updated_at_desc' }
    filter[:active] = true
    filter[:not_hidden] = true
    filter[:is_current_event] = false
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
