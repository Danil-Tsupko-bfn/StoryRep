Rails.application.routes.draw do
  resources :cars
#  get "up" => "rails/health#show", as: :rails_health_check

  root "cars#index"
end
