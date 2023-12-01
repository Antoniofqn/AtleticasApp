# frozen_string_literal: true

##
# API
#
module Api
  ##
  # Version 1
  #
  module V1
    class CurrentUsersController < Api::ApiController
      def index
        if current_user
          render json: { id: current_user.id, email: current_user.email }, status: :ok
        else
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      end
    end
  end
end
