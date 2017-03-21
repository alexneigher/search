Rails.application.routes.draw do
  
  resources :searches, param: :query

  root 'searches#new'
end
