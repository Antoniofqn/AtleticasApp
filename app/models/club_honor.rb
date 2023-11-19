class ClubHonor < ApplicationRecord
  ##
  # Associations
  #

  belongs_to :club

  ##
  # Validations
  #
  validates :title, :year, presence: true, allow_blank: false
end
