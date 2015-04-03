Rails.application.routes.draw do

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github, Facebook
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  resource :user do
    resources :schools, controller: 'users/schools' do
      resources :courses, controller: 'users/schools/courses' do

      end
    end
  end

  root to: 'visitors#index'
end
