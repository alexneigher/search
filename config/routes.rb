Rails.application.routes.draw do
  
  resources :searches, param: :query

  namespace :admin do
    
    resources :searches
  end

  root 'searches#new'
end
