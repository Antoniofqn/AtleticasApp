Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: %i[registrations confirmations], controllers: {
    passwords: 'devise_token_auth/passwords'
  }

  devise_for :admins, skip: :registration
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :api, defaults: { format: 'json' } do
    post '/s3-sign' => 'api#generate_presigned_aws_url'
    namespace :v1 do
      resources :users do
        collection do
          post '/authenticate' => 'users#authenticate'
          get :forgot_uid
        end
      end
    end
  end

end
