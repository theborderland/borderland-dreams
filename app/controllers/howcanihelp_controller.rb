class HowcanihelpController < ApplicationController
  include CanApplyFilters

  def index
    apply_filters
  end
end
