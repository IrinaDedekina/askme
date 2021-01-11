Rails.application.routes.draw do

  resources :users, except: [:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :questions
  root to: "users#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "sign_up" => "users#new"
  get "log_out" => "sessions#destroy"
  get "log_in" => "sessions#new"
end
