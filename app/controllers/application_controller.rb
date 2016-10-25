class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def not_found
    render file: "public/404.html", status: :not_found
  end

  def iframe_action
    response.headers.delete "X-Frame-Options"
    render_something
  end
  
  protected

	def configure_permitted_parameters
	   devise_parameter_sanitizer.for(:sign_up)        << :ticket_id
	end
end
