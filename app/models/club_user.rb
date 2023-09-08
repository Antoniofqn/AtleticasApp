# frozen_string_literal: true

class ClubUser < ApplicationRecord
  #
  # Associations
  #

  belongs_to :club
  belongs_to :user
end
