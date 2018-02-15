ActiveAdmin.register Person do
  permit_params :email, :phone_number, :background, :has_ticket, :needs_early_arrival

  scope :in_camp, default: true

  csv do
    column :name
    column :email
    column :phone_number
    column :background
    column :has_ticket
    column :needs_early_arrival
    column ("dream id") { |person| person.camp.id }
    column(t("form_dream_name")) { |person| person.camp.name }
    column(t("activerecord.attributes.person.roles")) { |person| person.roles.map(&:identifier).join(",") }
  end
end
