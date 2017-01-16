ActiveAdmin.register Person do
  csv do
    column :name
    column :email
    column :phone_number
    column :background
    column ("dream id") { |person| person.camp.id }
    column(t("form_dream_name")) { |person| person.camp.name }
    column(t("activerecord.attributes.person.roles")) { |person| person.roles.map(&:identifier).join(",") }
  end
end
