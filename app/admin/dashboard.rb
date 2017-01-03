ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    default_coins = 10

    columns do
      column do
        panel "Info" do
          para User.count.to_s + " registered users"
          para (User.count * default_coins).to_s + " Total available coins for all users"
          para Grant.sum(:amount).to_s + " coins were distributed"
          para (Grant.sum(:amount) * Rails.application.config.coin_rate).to_s + " amount of money distributed"
        end
      end
    end

    # app/admin/dashboard.rb
    panel I18n.t("activeadmin.recent_updated") do
      table_for PaperTrail::Version.order('id desc').limit(20) do # Use PaperTrail::Version if this throws an error
        #column ("Item") { |v| v.item }
        column (I18n.t("activeadmin.item")) { |v| link_to v.item.name, [:admin, v.item] } # Uncomment to display as link
        column (I18n.t("activeadmin.modified_at")) { |v| v.created_at.to_s :long }
        column (I18n.t("activerecord.models.user.one")) do |v|
            if(v.whodunnit)
              link_to User.find(v.whodunnit).email, [:admin, User.find(v.whodunnit)]
            end
          end
      end
    end
  end
end
