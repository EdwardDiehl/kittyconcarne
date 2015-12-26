Rails.application.routes.draw do
  resources :events, only: [:index] do
    collection do
      post :save
      post :remove
    end
  end

  root 'home#index'
end
