Rails.application.routes.draw do

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :questions, except: [:show, :new, :index]
  resources :hashtags, only: :show, param: :text
  root to: "users#index"

  get "sign_up" => "users#new"
  get "log_out" => "sessions#destroy"
  get "log_in" => "sessions#new"
end
