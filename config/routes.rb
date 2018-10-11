# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :projects
  resources :lists do
    post :move, on: :collection
  end
  resources :tasks do
    post :move, on: :collection
  end

  root to: 'projects#index'
end
