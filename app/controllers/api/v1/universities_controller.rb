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
      skip_before_action :authenticate_user!, only: %i[index show]

      def index
        if params[:query].present? || params[:category].present?
          @q = University.all
          @q = @q.where(category: params[:category]) if params[:category].present?
          @q = @q.search(params[:query]) if params[:query].present?
        else
          @q = University.all
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
    end
  end
end
