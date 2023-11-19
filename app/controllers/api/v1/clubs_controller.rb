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
    # Clubs on the system
    #
    class ClubsController < Api::ApiController
      before_action :set_club, only: %i[show update]

      def index
        if params[:university_hashid].present?
          @clubs = Club.where(university: University.find_by_hashid!(params[:university_hashid]))
        else
          @clubs = Club.all
        end
        render json: Api::V1::ClubSerializer.new(@clubs).serialized_json
      end

      def show
        render json: Api::V1::ClubSerializer.new(@club, { params: { action: :show}} ).serialized_json
      end

      def update
        authorize @club
        if @club.update(club_params)
          render json: Api::V1::ClubSerializer.new(@club).serialized_json
        else
          bad_request(@club.errors.full_messages)
        end
      end

      private

      def club_params
        params.require(:club).permit(:name, :description, :year_of_foundation, :logo_url)
      end

      def set_club
        @club = Club.find_by_hashid!(params[:id])
      end
    end
  end
end
