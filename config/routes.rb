Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'camps#index'
  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :camps do
    resources :images
  end

  post 'camps/:id/join' => 'camps#join'
  patch 'camps/:id/update_grants' => 'camps#update_grants'
  patch 'camps/:id/toggle_granting' => 'camps#toggle_granting'

end
