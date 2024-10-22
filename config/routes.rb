Rails.application.routes.draw do
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'
  post '/logout', to: 'auth#logout'
  get '/users', to: 'users#index'

  get "up" => "rails/health#show", as: :rails_health_check
end
