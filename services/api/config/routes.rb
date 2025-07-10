Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  mount MissionControl::Jobs::Engine, at: '/jobs'

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
  root 'pages#welcome'

  get '/welcome', to: 'pages#welcome'
  get '/features', to: 'pages#features'
  get '/faqs', to: 'pages#faqs'
  get '/developers_info', to: 'pages#developers_info'

  resource :session
  resource :password, param: :token
  resource :registration, only: %i[new create]
  resource :confirmation, only: %i[new show create]
  resources :stores, only: %i[index new create]

  scope '/:store_slug', as: :store do
    get '/', to: 'stores#show', as: :home
    get '/edit', to: 'stores#edit', as: :edit
    patch '/', to: 'stores#update', as: :update

    resource :store_membership, only: %i[show new create destroy]

    resources :user_downloads, only: %i[index show]

    resources :users, only: :destroy

    resources :appointments, only: %i[index show new create edit update] do
      resources :locations, only: %i[new create edit update]
      resource :appointment_add_ons, only: %i[edit update]
      resource :invoice, only: %i[create update] do
        get :download, on: :member
      end
    end

    resources :customers, only: %i[index show new create edit update]
    resources :pricings
    resource :settings, only: :show
    resources :showcases do
      member do
        delete :bulk_delete
      end
    end

    resources :photos, only: [:update]

    resources :galleries, only: %i[index new create edit update destroy] do
      resources :collections do
        resources :photos, only: %i[new create destroy] do
          collection do
            get :download
            delete :bulk_delete
          end
        end
      end

      resources :packages, only: %i[new create edit update destroy]
      resources :add_ons, only: %i[new create edit update destroy]
    end
  end
end
