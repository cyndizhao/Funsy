Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :compaigns, only:[:new, :create, :show, :edit, :destroy]
  root 'compaigns#new'
end
