# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'public_apis_v1/:table_name/:conditions', to: 'public_apis_v1#api', as: :result_public_api_v1
get 'public_apis_v2/:endpoint/:format_type', to: 'public_apis_v2#api', as: :result_public_api_v2

get 'public_apis/', to: 'public_apis#index', as: :public_apis
get 'public_apis/:table_name', to: 'public_apis#show', as: :public_api


resources :apis do
  member do
    patch 'update_status'
  end
end
