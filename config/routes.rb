Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

	root 'static_pages#home'

	get '/sign_up' => 'users#new'

	get 'login' => 'sessions#new'

	get '/:id' => 'users#show'

	post 'login' => 'sessions#create'

	delete 'logout' => 'sessions#destroy'


	resources :account_activations, only: [:edit]
	resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
