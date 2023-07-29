# frozen_string_literal: true

module DeviseTokenAuth
  class PasswordsController < DeviseTokenAuth::ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_user_by_token, only: %i[update]
    before_action :validate_redirect_url_param, only: %i[create edit]
    skip_after_action :update_auth_header, only: %i[create edit]

    include ApplicationHelper

    # this action is responsible for generating password reset tokens and
    # sending emails
    def create
      @resource = resource_class.find_by(email: create_params[:email])
      return render_create_error_missing_password if @resource.present? && @resource.encrypted_password.blank?

      if @resource
        if @resource.email_confirmed_at
          yield @resource if block_given?
          @resource.send_reset_password_instructions(
            email: @resource.email,
            provider: provider,
            redirect_url: @redirect_url,
            client_config: params[:config_name]
          )
          @resource.errors.empty? ? render_create_success : render_create_error(@resource.errors)
        else
          @resource.send_email_confirmation_instructions
          render_unconfirmed_email_error
        end
      else
        render_not_found_error
      end
    end

    # this is where users arrive after visiting the password reset confirmation link
    def edit


      # if a user is not found, return nil
      @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])

      if params[:post_action].present? && params[:post_action] == 'finish-signup'
        return redirect_to(ENV['DEVISE_SIGN_IN_REDIRECT_URL']) if @resource.blank?

        @redirect_url = ENV['DEVISE_RESET_PASSWORD_REDIRECT_URL']
      end

      if @resource.present? && @resource.reset_password_period_valid?

        client_id = token = @resource.create_token

        # ensure that user is confirmed
        @resource.skip_confirmation! if confirmable_enabled? && !@resource.confirmed_at

        # allow user to change password once without current_password
        @resource.allow_password_change = true if recoverable_enabled?

        @resource.save!(validate: false)

        yield @resource if block_given?

        redirect_header_options = { reset_password: true }
        redirect_headers = build_redirect_headers(token,
                                                  client_id,
                                                  redirect_header_options)

        @headers = { token: token.token, client: client_id.client, uid: @resource.uid }

        render 'devise/passwords/edit'
      else
        redirect_to(ENV['DEVISE_SIGN_IN_REDIRECT_URL'])
      end
    end

    def update

      @headers = { token: params[:token], client: params[:client], uid: params[:uid] }

      rc = User.find_by(uid: params[:uid])
      if @resource.blank? && rc&.valid_token?(params[:token], params[:client]) == true
        @resource = rc
      end

      # make sure user is authorized
      return render_update_error_unauthorized unless @resource

      @resource.allow_password_change = true

      # ensure that password params were sent
      unless params[:password] && params[:password_confirmation]
        return render_update_error_missing_password
      end

      @resource.skip_current_password_verification = true

      if @resource.update(password: params[:password], password_confirmation: params[:password_confirmation])
        @resource.allow_password_change = false if recoverable_enabled?
        @resource.confirmed_at = Time.zone.now if @resource.confirmed_at.blank?
        @resource.tokens&.delete(@token&.client)
        @resource.save!

        yield @resource if block_given?
        render_update_success
      else
        render 'devise/passwords/edit'
      end
    end

    protected

    def auth_url(token)
      return ENV['DEVISE_RESET_PASSWORD_REDIRECT_URL'] if token.blank?

      "#{ENV['DEVISE_RESET_PASSWORD_REDIRECT_URL']}/#{CGI.escape(token.client)}/#{CGI.escape(token.token)}/#{CGI.escape(@resource.uid)}"
    end

    def resource_update_method
      allow_password_change = recoverable_enabled? && @resource.allow_password_change == true
      if DeviseTokenAuth.check_current_password_before_update == false || allow_password_change
        'update_attributes'
      else
        'update_with_password'
      end
    end

    def render_create_error_missing_password
      render_error(401, I18n.t('devise_token_auth.passwords.missing_confirmation'))
    end

    def render_create_error_missing_email
      render_error(401, I18n.t('devise_token_auth.passwords.missing_email'))
    end

    def render_create_error_missing_redirect_url
      render_error(401, I18n.t('devise_token_auth.passwords.missing_redirect_url'))
    end

    def render_error_not_allowed_redirect_url
      response = {
        status: 'error',
        data:   resource_data
      }
      message = I18n.t('devise_token_auth.passwords.not_allowed_redirect_url', redirect_url: @redirect_url)
      render_error(422, message, response)
    end

    def render_create_success
      render json: {
        success: true,
        message: create_success_message
      }
    end

    def create_success_message
      I18n.t('devise_token_auth.passwords.create_success_email', email: masked_email(@resource.email))
    end

    def render_create_error(errors)
      render json: {
        success: false,
        errors: errors
      }, status: 400
    end

    def render_edit_error
      raise ActionController::RoutingError, 'Not Found'
    end

    def render_update_error_unauthorized
      render_error(401, I18n.t('devise_token_auth.passwords.invalid_tokens'))
    end

    def render_update_error_password_not_required
      render_error(422, I18n.t('devise_token_auth.passwords.password_not_required', provider: @resource.provider.humanize))
    end

    def render_update_error_missing_password
      render_error(422, I18n.t('devise_token_auth.passwords.missing_passwords'))
    end

    def render_update_success
      redirect_to ENV['DEVISE_RESET_PASSWORD_REDIRECT_URL']
    end

    def render_update_error
      render json: {
        success: false,
        errors: resource_errors
      }, status: 422
    end

    private

    def resource_params
      params.permit(:email, :reset_password_token)
    end

    def password_resource_params
      params.permit(*params_for_resource(:account_update) + [:first_name, :last_name, :reset_password_token])
    end

    def render_not_found_error
      render_error(404, I18n.t('devise_token_auth.passwords.user_not_found'))
    end

    def render_unconfirmed_email_error
      render_error(401, I18n.t('devise_token_auth.passwords.unconfirmed_email'))
    end

    def validate_redirect_url_param
      @redirect_url = ENV['DEVISE_RESET_PASSWORD_REDIRECT_URL']

      return render_create_error_missing_redirect_url unless @redirect_url
      return render_error_not_allowed_redirect_url if blacklisted_redirect_url?(@redirect_url)
    end

    ##
    # Render error if user given an invalid key for create a password recovery
    #
    def invalid_key
      render_error(401, I18n.t('devise_token_auth.passwords.invalid_key'))
    end

    ##
    # Render error if user given an invalid send_to for create a password recovery
    #
    def invalid_send_to
      render_error(401, I18n.t('devise_token_auth.passwords.invalid_send_to'))
    end

    ##
    # Params allowerd for create a password recovery
    #
    def create_params
      params.permit(:email)
    end
  end
end
