# frozen_string_literal: true

class ClubProposal < ApplicationRecord

  #
  # Associations
  #

  belongs_to :university

  #
  # Validations
  #

  validates :proposed_club_name, presence: true, allow_blank: false
  validates :proposer_email, presence: true, allow_blank: false
  validates :proposer_first_name, presence: true, allow_blank: false
  validates :proposer_last_name, presence: true, allow_blank: false

  #
  # Methods
  #

  def approve
    return false if approved # Ensure a proposal isn't approved multiple times

    Club.transaction do
      club = create_club
      user = create_user
      create_club_user(club, user)

      update(approved: true, approved_at: Time.current)
    end
  end

  private

  def create_club
    Club.create!(
      name: proposed_club_name,
      description: proposed_club_description,
      year_of_foundation: proposed_club_year_of_foundation,
      university_id: university.id,
      logo_url: proposed_club_logo_url
    )
  end

  def create_user
    password = SecureRandom.hex(32)
    User.create!(
      first_name: proposer_first_name,
      last_name: proposer_last_name,
      email: proposer_email,
      password: password,
      password_confirmation: password
    )
  end

  def create_club_user(club, user)
    ClubUser.create!(club_id: club.id, user_id: user.id)
  end
end
