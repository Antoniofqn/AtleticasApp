# frozen_string_literal: true

##
# Users should be Authenticatable
#
module Authenticatable
  extend ActiveSupport::Concern

  included do
    private

    ##
    # Sign in and generate fields for headers
    #
    def resource_authenticatable(params)
      set_resource(params)
      @headers = {}

      # From devise_auth_token sessions controller
      if @resource && @resource.errors.blank? && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        sign_in_resource(@resource)
      elsif @resource && @resource.errors.blank? && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        any = User.confirmation_keys == %i[any]
        @resource.errors.add(
          :base,
          I18n.t("activerecord.errors.models.user.attributes.base.confirm_#{any ? 'any' : 'all'}_fields", fields: @resource.unconfirmed_fields.map{ |field| @resource.locale_key(field) }.join(', '))
        )
      elsif !@resource
        @resource.errors.add(:base, I18n.t('devise_token_auth.sessions.bad_credentials'))
      end

      return @headers, @resource
    end

    ##
    # Sign in and generate fields for headers
    #
    def sign_in_resource resource
      @resource = resource
      @client_id = @token = @resource.create_token
      @resource.save
      sign_in(:user, @resource, store: false, bypass: false)
      generate_headers
      return @headers, @resource
    end

    ##
    # Authenticate resource from email or providers
    #
    def authenticate_resource params
      user = User.find_by_uid(params[:uid])
      if user.blank?
        { errors: [{ uid: I18n.t('devise_token_auth.sessions.bad_uid') }] }
      elsif !user.valid_password?(params[:password])
        { errors: [{ password: I18n.t('devise_token_auth.sessions.bad_password') }] }
      else
        user
      end
    end

    ##
    # Set resource depending on auth
    #
    def set_resource params
      resource = authenticate_resource(params)
      if resource.present? && resource.is_a?(ActiveRecord::Base)
        @resource = resource
      else
        @resource = User.new
        if resource[:errors].present?
          resource[:errors].each do |error|
            error.each do |key, value|
              @resource.errors.add(key, value)
            end
          end
        end
      end
    end

    ##
    # Generate headers for authenticatable
    #
    def generate_headers
      @headers['access-token'] = @token
      @headers['client'] = @client_id
      @headers['uid'] = @resource.uid
      @headers['expiry'] = ''
      @headers['token-type'] = 'bearer'
    end
  end
end
