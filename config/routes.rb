Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/appointments' => 'appointment#index', as: 'index'
  get '/appointments/:id' => 'appointment#show', as: 'show'

  post '/appointments' => 'appointment#create', as: 'create'

  delete '/appointments/:id' => 'appointment#destroy', as: 'destroy'
end
