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

  # access to reporting in a non-nested url
  # SAME_AS:: get 'time_entries/list', to: 'time_entries#list', as: 'list_time_entries'
  # ACCESSED_VIA:: <%= link_to "My Time Entries", list_time_entries_path %>
  resources :time_entries, only: [] do
    collection do
      get 'list'  # maps GET /time_entries/list to time_entries#list
    end
  end
  get 'report', to: 'time_entries#report'  # For reports
end
