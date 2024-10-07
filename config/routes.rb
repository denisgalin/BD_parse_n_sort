# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post 'transactions/sort', to: 'transactions#sort'
  get 'up' => 'rails/health#show', as: :rails_health_check

end
