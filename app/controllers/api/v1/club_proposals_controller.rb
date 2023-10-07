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
    # Club Proposals on the system
    #
    class ClubProposalsController < Api::ApiController
      before_action :set_club_proposal, only: %i[show update]

      def create
        @club_proposal = ClubProposal.new(club_proposal_params)
        @club_proposal.user = current_user
        authorize @club_proposal
        if @club_proposal.save
          render json: Api::V1::ClubProposalSerializer.new(@club_proposal).serialized_json
        else
          bad_request(@club_proposal.errors.full_messages)
        end
      end

      def index
      end

      def show
      end

      def update
      end

      private

      def club_proposal_params
        params.require(:club_proposal).permit(:proposed_club_name, :proposed_club_description,
                                              :proposed_club_year_of_foundation, :proposed_club_logo_url,
                                              :university_id)
      end

      def set_club_proposal
        @club_proposal = ClubProposal.find(params[:id])
      end
    end
  end
end
