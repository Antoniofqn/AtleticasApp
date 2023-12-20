Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
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
      resources :club_proposals, only: %i[create index show update] do
        member do
          post :approve
          post :disapprove
        end
      end
      resources :universities, only: %i[index show create]
      resources :clubs, only: %i[index create show update] do
        resources :club_honors, only: %i[create update destroy]
        resources :club_athletes, only: %i[create update destroy]
        resources :club_contents, only: %i[create update destroy]
      end
      resources :club_users, only: %i[index create destroy]
      resources :current_users, only: %i[index]
    end
  end

end
