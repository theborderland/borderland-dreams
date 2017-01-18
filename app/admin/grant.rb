ActiveAdmin.register Grant do

actions :index, :show
permit_params :user_id, :camp_id

end
