Rails.application.routes.draw do
  get '/version', to: 'version#show'
  get '/about' => 'high_voltage/pages#show', id: 'about'
  get '/license' => 'high_voltage/pages#show', id: 'license'
  Healthcheck.routes(self)
  root "home#index"
end
