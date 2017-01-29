ActiveAdmin.register Camp do
  member_action :show do
      @camp = Camp.includes(versions: :item).find(params[:id])
      @versions = @camp.versions 
      @camp = @camp.versions[params[:version].to_i].reify if params[:version]
      show!
  end

  member_action :history do
    @camp = Camp.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'Camp', item_id: @camp.id)
    render "layouts/history"
  end

  sidebar :versionate, :partial => "layouts/version", :only => :show
end