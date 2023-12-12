#frozen_string_literal

module Api
  module V1
    class UniversitySerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #
      attributes :name, :abbreviation, :state, :region, :category, :slug

      ##
      # Relationships
      #
      attribute :clubs do |object|
        object.clubs.map do |club|
          { name: club.name, slug: club.slug, logo_url: club.logo_url, club_hashid: club.hashid }
        end
      end
    end
  end
end
