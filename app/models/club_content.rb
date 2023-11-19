class ClubContent < ApplicationRecord
  ##
  # Associations
  #

  belongs_to :club

  ##
  # Validations
  #
  validates :content, presence: true, allow_blank: false
end
