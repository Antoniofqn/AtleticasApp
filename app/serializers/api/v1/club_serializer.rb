#frozen_string_literal

module Api
  module V1
    class ClubSerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #
      attributes :name, :description, :year_of_foundation, :logo_url, :slug

      ##
      # Relationships
      #
      belongs_to :university
      has_many :club_users
      has_many :users, through: :club_users
    end
  end
end
