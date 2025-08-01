Rails.application.routes.draw do
  devise_for :admins
  # resources :students
  resources :students do
    collection do
      post :import
      get :export
    end
  end

  get 'results', to: 'students#results'


  root 'home#index'
end
