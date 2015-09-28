Rails.application.routes.draw do
  namespace :api do
    resources :reviews, except: [:index, :new, :edit], defaults: { format: 'json' }, constraints: { format: 'json' }
  end
end
