Rails.application.routes.draw do
  resources :projects
  resources :tasks
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # RESTful project/task/time_entry nesting
  resources :projects do
    resources :tasks do
      resources :time_entries
    end
  end

  resources :tasks do
    collection do
      get "list"
    end
  end

  # Global non-nested access to time_entries
  resources :time_entries do  #, only: [ :new, :create ] do
    collection do
      get "list"  # /time_entries/list
    end
  end

  # Optional report route
  get "report", to: "time_entries#report"

  # Set new root path to new time entry as our starting page
  root to: "home#index"
end
