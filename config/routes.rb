Rails.application.routes.draw do

	root 'static_pages#home'

	get '/sign_up' => 'users#new'

	get 'login' => 'sessions#new'

	#get '/:id' => 'users#show'

	post 'login' => 'sessions#create'

	delete 'logout' => 'sessions#destroy'

	get 'user/:id' => 'users#show'

	get 'user/:username' => 'users#show'

	resources :account_activations, only: [:edit]

	resources :users, path: "", only: [:index, :show]
	get '*id', to: 'users#index'

	resources :users do 
		collection do 
			get 'search'
		end
	end
	resources :password_resets, only: [:new, :create, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
