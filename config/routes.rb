Rails.application.routes.draw do
  get 'play', to: 'games#play'

  get 'score', to: 'games#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
