Rails.application.routes.draw do
  devise_for :users

  get 'welcome', to: 'welcome#index'

  resources :quick_registrations, only: [:new, :create]

  scope except: :show do
    resources :edit_users
    resources :apaches do
      member { get :before_destroy }
      resources :vhosts
    end
    resources :rails_servers
    resources :domains do
      resources :dns_records
    end
    resources :email_domains do
      resources :email_users
      resources :email_aliases
    end
    resources :ftps
    resources :mysql_users do
      resources :mysql_dbs
    end
    resources :pgsql_users do
      resources :pgsql_dbs
    end
    resources :system_users
    resources :system_groups
    resources :system_user_shells
    resources :ip_addresses
    resources :registrars
    resources :ssl_cert_chains
  end
  resources :settings, except: [:show, :new, :create, :destroy]

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root to: 'welcome#index'
end
