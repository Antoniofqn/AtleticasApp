# frozen_string_literal: true

##
# API
#
module Api
  ##
  # Controller from which all ApiControllers descend
  #
  class ApiController < BaseApiController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pundit
    before_action :authenticate_user!

    private

    ##
    # Set pundit user
    #
    def pundit_user
      current_user
    end

    def current_authenticated
      current_user
    end

    protected

    ##
    # Define index scope
    #
    def scope
      model = model_from_controller(self.class)
      return model if model

      custom_scope_method_name = "#{controller_name}_scope"
      respond_to?(custom_scope_method_name, true) ? send(custom_scope_method_name) : nil
    end

    def comparatives_scope
      nil
    end
  end
end
