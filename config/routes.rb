Rails.application.routes.draw do

  #devise_for :users
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # LinkedIn authentication routes 
  #get '/auth/linkedin/callback' => 'sessions#create'
  #get '/auth/linkedin', to: "sessions#auth", as: :linkedin_auth
  
  get '/logout', to: 'sessions#destroy', as: :logout
  get '/auth/:provider/callback', to: 'sessions#create'
  #get '/auth/linkedin/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#auth_failure'
  
  # Authentication routes
  resources :sessions
  resources :users
  get 'users/:id/change_password', to: 'users#change_password', as: :change_password
  
  get '/users/:id', to: 'users#show', as: :account
  #get 'users/new', to: 'users#new', as: :signup
  #get 'user/edit', to: 'users#edit', as: :edit_current_user
  get '/login', to: 'sessions#new', as: :login
  get 'users/new', to: 'users#create', as: :signup
  get 'users/:id/create_profile', to: 'users#profile', as: :create_profile
  get 'users/:id/setup_account', to: 'users#setup', as: :setup_account 
  get 'users/:id/deactivate', to: 'users#deactivate', as: :deactivate 
  get 'users/:id/update', to: 'users#update', as: :update_user
  #post '/sessions' => "sessions#create"
  #get '/logout' => "sessions#destroy"

  #resources :users, :only => [:new, :create]

  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :mentees
  resources :mentors
  resources :mentorships
  
  #mentee matches route 
  get 'mentees/:id/matches', to: 'mentees#matches', as: :mentee_matches
  get 'mentees/:id/pause', to: 'mentees#pause', as: :pause_mentee
  put 'mentees/:id/pause', to: 'mentees#update_pause', as: :update_pause_mentee
  
  #mentor matches route 
  get 'mentors/:id/requests', to: 'mentors#requests', as: :mentor_requests
  get 'mentors/:id/pause', to: 'mentors#pause', as: :pause_mentor
  put 'mentors/:id/pause', to: 'mentors#update_pause', as: :update_pause_mentor
  
  # Routes for searching
  get 'mentees/search', to: 'mentees#search', as: :mentees_search
  get 'mentors/search', to: 'mentors#search', as: :mentors_search
  get 'users/search', to: 'users#search', as: :users_search

  # You can have the root of your site routed with 'root'
  root 'home#index'
  
  # cancancan for Authorization
  gem 'cancancan'
end