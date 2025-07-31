Rails.application.routes.draw do
  devise_for :admins
  resources :students

  root 'home#index'
end
