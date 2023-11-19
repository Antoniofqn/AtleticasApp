#frozen_string_literal

module Api
  module V1
    class ClubUserSerializer < Api::ApiSerializer
      ##
      # Set object's id
      #
      set_id :hashid

      ##
      # Attributes
      #

      attribute :user do |object|
        { name: object.user.name,
          hashid: object.user.hashid }
      end

      attribute :club do |object|
        { name: object.club.name,
          hashid: object.club.hashid,
          university: { name: object.club.university.name,
                        hashid: object.club.university.hashid }
        }
      end
    end
  end
end
