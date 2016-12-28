Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, skip: :all
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
      end
      resources :hotels, only: [:index]
      resources :bookings, only: [:create, :index] do
        collection do
          get '/:user_id' => 'bookings#for_user'
        end
      end
    end
  end
end
