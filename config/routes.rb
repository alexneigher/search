Rails.application.routes.draw do
  
  resources :searches, param: :query

  namespace :admin do
    resources :searches do
      put :fetch_new_cache
    end
  end

  root 'searches#new'
end
