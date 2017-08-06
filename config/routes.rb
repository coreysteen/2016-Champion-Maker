Rails.application.routes.draw do
  get 'champion/home'

  get 'champion/about'
  get 'champion/addPlayer' 

  get 'champion/draft'

  resources :players
  
  root 'champion#home'

  get "champion/home" => "champion#home"

  



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
