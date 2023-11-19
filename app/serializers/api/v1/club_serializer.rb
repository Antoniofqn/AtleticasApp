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

      attribute :university do |object|
        { name: object.university.name,
          slug: object.university.slug,
          hashid: object.university.hashid }
      end
    end
  end
end
