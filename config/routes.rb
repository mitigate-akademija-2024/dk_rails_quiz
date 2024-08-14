Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root "quizzes#index"
  get "/start_quiz", to: "quizzes#start"
  resources :high_scores, only: [:index, :show]

  resources :quizzes do
    get "my_quizzes", on: :collection
    put "submit_feedback", on: :member
    post "send_invitation", on: :member
    get "all_feedback", on: :collection
  resources :questions, shallow: true
    get "continue", on: :member
    get "completed", on: :collection
    get "do_quiz", on: :member
    post "submit_quiz", on: :member
    get "result", on: :member
    get 'all_high_scores', on: :collection

  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end