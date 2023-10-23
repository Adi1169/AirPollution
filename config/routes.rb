Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  if  Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => "/sidekiq" # monitoring console
  end

  resources :locations, only: [:index, :show] do
    collection do
      post 'create_location_using_coordinates'
      post 'create_location_direct'
    end
  end

  # :type can be 1 => 'average_per_month', 2 => 'average_per_month_per_location', 3 => 'average_per_state'
  get 'air_pollution/average/:type' , to: 'air_pollution#average'
end
