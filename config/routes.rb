Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    omniauths: "users/omniauths",
    passwords: "users/passwords",
    registrations: "users/registrations",
    sessions: "users/sessions",
    unlocks: "users/unlocks"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homes#landing_page"
end
