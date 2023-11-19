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
    return false if joined_at.blank? || left_at.blank?

    errors.add(:joined_at, 'must be before left at') if joined_at > left_at
  end
end
