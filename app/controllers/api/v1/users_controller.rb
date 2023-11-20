# frozen_string_literal: true

##
# API
#
module Api
  ##
  # Version 1
  #
  module V1
    ##
    # Users on the system
    #
    class UsersController < Api::ApiController
      include Authenticatable
      skip_before_action :authenticate_user!, only: %i[authenticate create forgot_uid
                                                       resend_email_confirmation]
      before_action :set_user, only: %i[destroy show update]
      skip_after_action :update_auth_header, only: %i[destroy]
      before_action :set_user_to_confirm_phone, only: %i[confirm_phone resend_phone_confirmation]

      ##
      # Authenticate a User using omniauth
      #
      def authenticate
        @headers, @user = resource_authenticatable(sign_in_params)
        define_response_auth_headers(@headers)
        if @user.errors.blank?
          render json: Api::V1::UserSerializer.new(@user).serialized_json
        else
          parse_login_errors
          unauthorized(@user.errors.full_messages, @code)
        end
      end

      ##
      # Create a User
      #
      def create
        @user = User.new(user_params)
        if @user.save
          render json: Api::V1::UserSerializer.new(@user).serialized_json
        else
          bad_request(@user.errors.full_messages)
        end
      end

      ##
      # Destroy the User Record
      #
      def destroy
        authorize @user
        @user.destroy
        render 'api/destroy'
      end

      ##
      # Forgot uid
      #
      def forgot_uid
        get_user_by_key(:email)
        @user.send_forgot_uid_notification
        if @user.errors.blank? && @user.save
          @message = I18n.t('api.messages.forgot_uid', key: @user.locale_key(:email), value: @user.email)
          render('api/success')
        else
          bad_request(@user.errors.full_messages)
        end
      end

      ##
      # Get users based on search
      #
      def index
        @q = policy_scope(scope)
        @users = @q.page(params[:page]).per(params[:per_page])
        authorize @users
        render json: Api::V1::UserSerializer.new(@users, meta: serializer_meta(@users, @q)).serialized_json
      end

      ##
      # Resend confirmation email
      #
      def resend_email_confirmation
        get_user_by_key(:email)
        return bad_request(I18n.t(['api.errors.email_already_confirmed'])) if @user.email_confirmed_at

        @user.send_email_confirmation_instructions.save(validate: false)
        @message = I18n.t('api.messages.resend_email_confirmation', email: @user.email)
        render 'api/success'
      end

      ##
      # Display User information
      #
      def show
        authorize @user
        render json: Api::V1::UserSerializer.new(@user).serialized_json
      end

      ##
      # Update a User
      #
      def update
        authorize @user
        if @user.update(user_params)
          render json: Api::V1::UserSerializer.new(@user).serialized_json
        else
          bad_request(@user.errors.full_messages)
        end
      end

      private

      ##
      # Set user by key from params
      #
      def get_user_by_key(key, standardize: false)
        @user = User.find_by!("#{key}": (standardize ? standardize_field(params[key.to_sym]) : params[key.to_sym]))
      end

      ##
      # Set user from params
      #
      def set_user
        @user = User.find_by_hashid!(params[:id])
      end

      ##
      # Set auth headers
      #
      def define_response_auth_headers(headers = nil)
        return nil if @user.blank? && headers.blank?

        headers ||= @user.create_new_auth_token
        headers.merge!('hashid' => @user.hashid)
        headers.each { |key, value| response.set_header(key, value) }
      end

      ##
      # Parse login errors
      #
      def parse_login_errors
        return nil if @user.blank? || @user.errors.blank?

        if @user.errors.messages.keys.include?(:uid)
          @code = 'uid'
          keys = [:uid]
        elsif @user.errors.messages.keys.include?(:password)
          @code = 'password'
          keys = [:password]
        end
        move_user_errors_to_base(keys)
        @user
      end

      ##
      # Move user errors to base
      #
      def move_user_errors_to_base(keys = [])
        return nil if @user.blank? || @user.errors.blank? || keys.blank?

        keys.each do |key|
          @user.errors.messages[key].each do |message|
            @user.errors.add(:base, message)
          end
          @user.errors.delete(key)
        end
      end

      ##
      # Allowed Parameters
      #
      def sign_in_params
        params.permit(:uid, :password)
      end

      ##
      # Allowed Parameters
      #
      def user_params
        params.fetch(:user).permit(*user_allowed_params)
      end

      ##
      # List of user allowed params
      #
      def user_allowed_params
        %i[ birth_date current_password email first_name gender last_name
            password password_confirmation profile_picture_url ]
      end
    end
  end
end
