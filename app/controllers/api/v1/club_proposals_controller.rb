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
      before_action :set_university, only: %i[create update]

      def create
        @club_proposal = ClubProposal.new(club_proposal_params)
        @club_proposal.user = current_user
        @club_proposal.university = @university
        authorize @club_proposal
        if @club_proposal.save
          render json: Api::V1::ClubProposalSerializer.new(@club_proposal).serialized_json
        else
          bad_request(@club_proposal.errors.full_messages)
        end
      end

      def index
        @club_proposals = policy_scope(ClubProposal)
        authorize @club_proposals
        render json: Api::V1::ClubProposalSerializer.new(@club_proposals).serialized_json
      end

      def show
        authorize @club_proposal
        render json: Api::V1::ClubProposalSerializer.new(@club_proposal).serialized_json
      end

      def update
        @club_proposal.university = @university if @university.present?
        authorize @club_proposal
        if @club_proposal.update(club_proposal_params.except(:university_id))
          render json: Api::V1::ClubProposalSerializer.new(@club_proposal).serialized_json
        else
          bad_request(@club_proposal.errors.full_messages)
        end
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

      def set_university
        @university = University.find_by_hashid!(club_proposal_params[:university_id])
      end
    end
  end
end
