# frozen_string_literal: true

##
# API
#
module Api
  ##
  # Version 1
  #
  module V1
    ##
    # Club Athletes on the system
    #
    class ClubAthletesController < Api::ApiController
      before_action :set_club_athlete, only: %i[update destroy]
      skip_before_action :authenticate_user!, only: %i[create update destroy]

      def create
        @club_athlete = ClubAthlete.new(club_athlete_params)
        @club_athlete.club = Club.find(params[:club_id])
        authorize @club_athlete
        if @club_athlete.save
          render json: Api::V1::ClubAthleteSerializer.new(@club_athlete).serialized_json
        else
          bad_request(@club_athlete.errors.full_messages)
        end
      end

      def update
        authorize @club_athlete
        if @club_athlete.update(club_athlete_params)
          render json: Api::V1::ClubAthleteSerializer.new(@club_athlete).serialized_json
        else
          bad_request(@club_athlete.errors.full_messages)
        end
      end

      def destroy
        authorize @club_athlete
        @club_athlete.destroy
        render 'api/destroy'
      end

      private

      def club_athlete_params
        params.require(:club_athlete).permit(:name, :achievements, :joined_at, :left_at)
      end

      def set_club_athlete
        @club_athlete = ClubAthlete.find(params[:id])
      end
    end
  end
end
