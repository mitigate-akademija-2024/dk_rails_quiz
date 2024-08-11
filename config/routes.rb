Rails.application.routes.draw do
  devise_for :users
  resources :quizzes
  root "quizzes#index"
  get "/start_quiz", to: "quizzes#start"
  resources :quizzes do
    resources :questions, shallow: true
    get "continue", on: :member
    get "completed", on: :collection
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end