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
        if params[:query].present?
          @universities = University.search(params[:query])
        else
          @universities = University.all
        end
        render json: Api::V1::UniversitySerializer.new(@universities).serialized_json
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
