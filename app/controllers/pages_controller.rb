class PagesController < ApplicationController
  def show
    if Rails.root.join('app', 'views', 'pages', "#{params[:page]}.html.erb").file?
      render template: "pages/#{params[:page]}"
    else
      render file: "public/404.html", status: :not_found
    end
  end
end
