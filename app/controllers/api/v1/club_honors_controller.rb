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
    # Club Honors on the system
    #
    class ClubHonorsController < Api::ApiController
      before_action :set_club_honor, only: %i[update destroy]
      skip_before_action :authenticate_user!, only: %i[create update destroy]

      def create
        @club_honor = ClubHonor.new(club_honor_params)
        @club_honor.club = Club.find(params[:club_id])
        authorize @club_honor
        if @club_honor.save
          render json: Api::V1::ClubHonorSerializer.new(@club_honor).serialized_json
        else
          bad_request(@club_honor.errors.full_messages)
        end
      end

      def update
        authorize @club_honor
        if @club_honor.update(club_honor_params)
          render json: Api::V1::ClubHonorSerializer.new(@club_honor).serialized_json
        else
          bad_request(@club_honor.errors.full_messages)
        end
      end

      def destroy
        authorize @club_honor
        @club_honor.destroy
        render 'api/destroy'
      end

      private

      def club_honor_params
        params.require(:club_honor).permit(:title, :description, :year)
      end

      def set_club_honor
        @club_honor = ClubHonor.find(params[:id])
      end
    end
  end
end
