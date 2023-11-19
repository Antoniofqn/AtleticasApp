#frozen_string_literal

module Api
  module V1
    class ClubUsersController < Api::ApiController
      before_action :set_club_user, only: %i[destroy]

      def index
        @club_users = policy_scope(ClubUser)
        @club_users.where(club: Club.find_by_hashid!(params[:club_hashid])) if params[:club_hashid].present?
        render json: Api::V1::ClubUserSerializer.new(@club_users).serialized_json
      end

      def create
        club = Club.find_by_hashid!(club_user_params[:club_id])
        user = User.find_by!(email: club_user_params[:user_email])
        @club_user = ClubUser.new(club: club, user: user)
        authorize @club_user
        if @club_user.save
          render json: Api::V1::ClubUserSerializer.new(@club_user).serialized_json
        else
          bad_request(@club_user.errors.full_messages)
        end
      end

      def destroy
        authorize @club_user
        @club_user.destroy
        render 'api/destroy'
      end

      private

      def club_user_params
        params.require(:club_user).permit(:user_email, :club_id)
      end

      def set_club_user
        @club_user = ClubUser.find_by_hashid!(params[:id])
      end
    end
  end
end
