# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "test#index"

  namespace "api" do
    namespace "v1" do
      post "image_annotate", to: "image_annotate#show"
      resources :users do
        resources :items, module: :users
        collection do
          post :signup, to: "users#create"
          post :login, to: "users#login"
          get :current_user
        end
      end
    end
  end
end
