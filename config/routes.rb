Rails.application.routes.draw do
  
  resources :searches

  root 'searches#new'
end
