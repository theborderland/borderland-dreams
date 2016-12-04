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
          para "Coins distribution " + Grant.group(:amount).count.to_s
        end
      end
    end
  end
end
