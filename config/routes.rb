Rails.application.routes.draw do
  namespace :admin do
    resources :administrators
    resources :clubs
    resources :club_proposals
    resources :club_users
    resources :universities
    resources :users

    root to: "administrators#index"
  end

  mount_devise_token_auth_for 'User', at: 'auth', skip: %i[registrations confirmations], controllers: {
    passwords: 'devise_token_auth/passwords'
  }

  devise_for :administrators, skip: :registration

  namespace :api, defaults: { format: 'json' } do
    post '/s3-sign' => 'api#generate_presigned_aws_url'
    namespace :v1 do
      resources :users do
        collection do
          post '/authenticate' => 'users#authenticate'
          get :forgot_uid
        end
      end
      resources :club_proposals, only: %i[create index show update]
    end
  end

end
