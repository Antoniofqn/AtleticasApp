#frozen_string_literal

module Api
  module V1
    class ClubHonorSerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #
      attributes :title, :year, :description
    end
  end
end
