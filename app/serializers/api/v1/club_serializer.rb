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

      attribute :club_athletes, if: proc { |object, params| params[:action] == :show } do |object|
        ClubAthleteSerializer.new(object.club_athletes).serializable_hash
      end

      attribute :club_honors, if: proc { |object, params| params[:action] == :show } do |object|
        ClubHonorSerializer.new(object.club_honors).serializable_hash
      end

      attribute :club_content, if: proc { |object, params| params[:action] == :show } do |object|
        ClubContentSerializer.new(object.club_content).serializable_hash
      end

      attribute :university do |object|
        { name: object.university.name,
          slug: object.university.slug,
          hashid: object.university.hashid }
      end
    end
  end
end
