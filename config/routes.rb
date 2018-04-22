Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
	  	scope :v1 do
		    resources :users, only: [:create, :update] do
			  collection do
			    post 'confirm'
			    post 'login'
			    post 'email_update'
			    post 'verify_user'
			  end
			end
			post 'passwords/forgot', to: 'passwords#forgot'
			post 'passwords/reset', to: 'passwords#reset'
			put 'passwords/update', to: 'passwords#update'

    		resources :incidents, path: 'ocorrencias'
    		resources :profiles, except: [:index, :show], path: 'perfil'
    		get 'perfil', to: 'profiles#show'
    		get 'perfil/ocorrencias', to: 'incidents#user_incidents'
		end

    end
end
