ActiveAdmin.register Ticket do
  permit_params :id_code, :email, :remote_user_id

end
