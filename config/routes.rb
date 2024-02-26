Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  
  devise_for :users
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  resources :users, only: [:index, :edit, :show, :update]
  root 'static_pages#landing_page'
  
  get 'activity', to: 'static_pages#activity'
  get "privacy_policy", to: "static_pages#privacy_policy"
  # get 'static_pages/landing_page'
  # get 'static_pages/privacy_policy'
 
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
