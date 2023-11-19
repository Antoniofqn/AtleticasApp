#frozen_string_literal

module Api
  module V1
    class ClubContentSerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #
      attributes :content
    end
  end
end
