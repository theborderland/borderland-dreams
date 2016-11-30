class PagesController < ApplicationController
  def show
    if valid_page?
      render template: "pages/#{params[:page]}"
    else
      render file: "public/404.html", status: :not_found
    end
  end

  def letsencrypt
    # use your code here, not mine
    render text: "XCSK74TMTjdxsmlje8ERFzzgAxAJTbf-MqHtJ3AIB9A.OPfzQCe-6IJckbcLeowmzjpFg1SaDjMKeZeG53T_3mA"
  end

  private
  def valid_page?
    File.exist?(Pathname.new(Rails.root + "app/views/pages/#{params[:page]}.html.erb"))
  end

end
