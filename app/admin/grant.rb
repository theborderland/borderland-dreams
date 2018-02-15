ActiveAdmin.register Grant do
  permit_params :user_id, :camp_id, :amount

  actions :index, :show
end
