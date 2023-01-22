Rails.application.routes.draw do
  resources :channels
  get '/version', to: 'version#show'
  get '/about' => 'high_voltage/pages#show', id: 'about'
  Healthcheck.routes(self)
  root "home#index"
end
