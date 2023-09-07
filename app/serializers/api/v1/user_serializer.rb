# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #
      attributes :email, :first_name, :last_name, :profile_picture_url
    end
  end
end
