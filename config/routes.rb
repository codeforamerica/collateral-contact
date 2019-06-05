Rails.application.routes.draw do
  resources :clients
  root 'pages#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "case_worker", to: "pages#case_worker"
  mount Cfa::Styleguide::Engine => "/cfa"
end
