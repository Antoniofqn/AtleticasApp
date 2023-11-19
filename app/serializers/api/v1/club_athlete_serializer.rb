#frozen_string_literal

module Api
  module V1
    class ClubAthleteSerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #
      attributes :name, :achievements, :joined_at, :left_at
    end
  end
end
