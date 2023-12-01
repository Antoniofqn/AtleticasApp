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
    class ClubContentsController < Api::ApiController
      before_action :set_club_content, only: %i[update destroy]
      skip_before_action :authenticate_user!, only: %i[create update destroy]

      def create
        @club_content = ClubContent.new(club_content_params)
        @club_content.club = Club.find(params[:club_id])
        authorize @club_content
        if @club_content.save
          render json: Api::V1::ClubContentSerializer.new(@club_content).serialized_json
        else
          bad_request(@club_content.errors.full_messages)
        end
      end

      def update
        authorize @club_content
        if @club_content.update(club_content_params)
          render json: Api::V1::ClubContentSerializer.new(@club_content).serialized_json
        else
          bad_request(@club_content.errors.full_messages)
        end
      end

      def destroy
        authorize @club_content
        @club_content.destroy
        render 'api/destroy'
      end

      private

      def club_content_params
        params.require(:club_content).permit(:content)
      end

      def set_club_content
        @club_content = ClubContent.find(params[:id])
      end
    end
  end
end
