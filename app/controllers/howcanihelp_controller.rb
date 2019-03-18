class HowcanihelpController < ApplicationController
  include CanApplyFilters
  before_action :apply_filters, only: :index

  def index
  end

  private

  def is_cocreation?
    true
  end
end
