Rails.application.routes.draw do
  get 'search', to: 'pages#search'
  get 'suggest', to: 'pages#autocomplete'
  root "pages#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
