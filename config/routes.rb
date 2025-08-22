Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    omniauths: "users/omniauths",
    passwords: "users/passwords",
    registrations: "users/registrations",
    sessions: "users/sessions",
    unlocks: "users/unlocks"
  }
  devise_scope :user do
    get "users/show", to: "users/registrations#show", as: "user_profile"
  end
  resources :questionnaires do
    post "csv/create", to: "questionnaires#create_from_csv"
    resource :questions, only: [:show, :edit, :update] do
      delete ":id", to: "questions#destroy"
    end

    resources :submissions
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homes#landing_page"

  match "/:status", to: "errors#show", constraints: {status: /\d{3}/}, via: :all
end
