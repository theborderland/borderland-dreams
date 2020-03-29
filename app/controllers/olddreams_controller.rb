class OlddreamsController < ApplicationController
  include CanApplyFilters
  before_action :apply_filters, only: :index
  before_action :load_lang_detector, only: [:show, :index]

  def index
    @camps = @camps.where(is_public: true, active: false)
  end

  private

  def is_active?
    false
  end
  def load_lang_detector
    @detector = StringDirection::Detector.new(:dominant)
  end
end
