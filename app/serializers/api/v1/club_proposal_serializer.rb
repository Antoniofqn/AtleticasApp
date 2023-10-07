# frozen_string_literal: true

module Api
  module V1
    class ClubProposalSerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #
      attributes :proposed_club_name, :proposed_club_description, :proposed_club_year_of_foundation, :proposed_club_logo_url,
                 :approved, :approved_at, :remarks

      ##
      # Relationships
      #
      belongs_to :university
      belongs_to :user
  end
end
