Rails.application.routes.draw do
  namespace :api do
    resources :reviews, except: [:new, :edit], defaults: { format: 'json' }, constraints: { format: 'json' } do
      resources :comments, except: [:new, :edit], defaults: { format: 'json' }, constraints: { format: 'json' }
    end
  end
end
