Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/appointments/:id' => 'appointment#show', as: 'show'
  get '/appointments' => 'appointment#index', as: 'index'
end
