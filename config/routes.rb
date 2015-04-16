Rails.application.routes.draw do

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github, Facebook
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  resources :user_sessions, only: [:new, :destroy, :create]

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  resource :user do
    resources :conversations, only: [:index, :show], controller: 'users/conversations'
    resources :schools, controller: 'users/schools' do
      resources :courses, controller: 'users/schools/courses' do
        resources :events, controller: 'users/schools/courses/events' do
          member do
            patch :toggle_attendance
          end
        end

      end
    end
  end

  root to: 'visitors#index'
end
