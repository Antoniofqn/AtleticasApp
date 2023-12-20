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
    # Universities on the system
    #
    class UniversitiesController < Api::ApiController
      before_action :set_university, only: %i[show]
      skip_before_action :authenticate_user!, only: %i[index show create]

      def create
        @university = University.new(university_params)
        authorize @university
        if @university.save
          render json: Api::V1::UniversitySerializer.new(@university).serialized_json
        else
          bad_request(@university.errors.full_messages)
        end
      end

      def index
        if params[:query].present? || params[:category].present?
          @q = policy_scope(University)
          @q = @q.where(category: params[:category]) if params[:category].present?
          @q = @q.search(params[:query]) if params[:query].present?
        else
          @q = policy_scope(University)
        end
        @universities = @q.page(params[:page]).per(params[:per_page])
        render json: Api::V1::UniversitySerializer.new(@universities, meta: serializer_meta(@universities, @q)).serialized_json
      end

      def show
        render json: Api::V1::UniversitySerializer.new(@university).serialized_json
      end

      private

      def set_university
        @university = University.find_by_hashid!(params[:id])
      end

      def university_params
        params.require(:university).permit(:name, :state, :category, :abbreviation)
      end
    end
  end
end
