# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'public_apis/:table_name/:conditions', to: 'public_apis#api', as: :result_public_api
get 'public_apis/', to: 'public_apis#index', as: :public_apis
get 'public_apis/:table_name', to: 'public_apis#show', as: :public_api
