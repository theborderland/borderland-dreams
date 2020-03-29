module CanApplyFilters
  def apply_filters
    params[:filterrific] ||= { sorted_by: 'random' }
    @filterrific = initialize_filterrific(Camp, params[:filterrific].merge(
      active: is_active?,
      not_hidden: !(current_user&.admin? || current_user&.guide?),
      is_cocreation: is_cocreation?
    ), select_options: {
        tagged_with: Camp.options_for_tags
    })
    @camps = @filterrific&.find
  end

  private

  def is_cocreation?
    false
  end

  def is_active?
    true
  end
end
