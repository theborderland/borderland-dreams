module CanApplyFilters
  def apply_filters
    hidden = current_user&.admin? || current_user&.guide?
    @filterrific = initialize_filterrific(Camp, params.fetch(:filterrific, {}).merge(
      is_cocreation: true,
      active: true,
      hidden: hidden,
      not_hidden: !hidden
    ))
    @camps = @filterrific.find.page(params[:page])
  end
end
