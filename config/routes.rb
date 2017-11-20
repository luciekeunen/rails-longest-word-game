Rails.application.routes.draw do
  get 'logins/create'

  get 'play', to: 'games#play'

  get 'score', to: 'games#score'

  root to: 'games#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
