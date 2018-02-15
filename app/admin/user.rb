ActiveAdmin.register User do
  permit_params :email, :provider, :guide, :admin, :grants

end
