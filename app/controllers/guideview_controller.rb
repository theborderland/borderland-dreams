class GuideviewController < ApplicationController
  def index
    @camps = Camp.where(:is_current_event: true).find_each
  end
end