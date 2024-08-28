Rails.application.routes.draw do
  resources :ridings, only: [:index, :show, :edit, :update] do
    resources :polling_locations, only: [:create]
  end
  resources :polling_locations, only: [:create]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "ridings#index"
end
