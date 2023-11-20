class ClubAthlete < ApplicationRecord

  ##
  # Associations
  #

  belongs_to :club

  ##
  # Validations
  #

  validates :name, presence: true, allow_blank: false
  validate :joined_at_before_left_at_valid?

  ##
  # Methods
  #

  def joined_at_before_left_at_valid?
    return true if joined_at && left_at && joined_at < left_at

    errors.add(:joined_at, 'must be before left at')
    false
  end
end
