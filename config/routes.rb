Rails.application.routes.draw do
  resources :users, except: [ :index, :show, :edit, :destroy ]
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  #

  get "app/dashboard"    => "app#dashboard", as: :app_dashboard

  get "app/database"     => "app#database", as: :app_database
  get "app/database/new" => "databases#new", as: :new_database
  get "app/database/:id" => "app#database", as: :app_database_show

  get "layout/:id" => "layouts#show"

  resources :databases, except: [ :index, :new ]
  post "databases/:id/new_row" => "databases#new_row", as: :new_row_database
  patch "databases/:id/:row" => "databases#update_row", as: :update_row_database
  delete "databases/:id/:row" => "databases#delete_row", as: :delete_row_database

  post "databases/:id/new_column" => "databases#new_column", as: :new_column_database
  patch "databases/:id/scheme/name" => "databases#update_scheme_name"

  get "app" => redirect("/app/dashboard")
  root to: redirect("/app/dashboard")
end
