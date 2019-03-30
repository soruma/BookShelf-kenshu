# frozen_string_literal: true

Rails.application.routes.draw do
  resources :authors, only: [ :index ]
end
