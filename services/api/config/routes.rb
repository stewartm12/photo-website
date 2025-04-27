Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  post '/graphql', to: 'graphql#execute'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get '/favicon.ico', to: proc { [204, {}, []] }

  # Defines the root path route ("/")
  root 'welcome#index'

  resource :session
  resource :password, param: :token
  resource :registration, only: %i[new create]
  resource :confirmation, only: %i[new show create]
  resources :stores, only: %i[index new create]

  scope '/:store_slug', as: :store do
    resource :store_session, only: %i[new create]

    get '/', to: 'stores#show', as: :home
    get '/edit', to: 'stores#edit', as: :edit
    patch '/', to: 'stores#update', as: :update

    resources :galleries, only: %i[show]
    resources :collections, only: %i[show]
    resources :appointments, only: %i[show edit update]
  end
end
