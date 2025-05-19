Rails.application.routes.draw do
  resources :tasks
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :projects do
    resources :tasks do
      resources :time_entries
    end
  end

  root to: "projects#index"
end
