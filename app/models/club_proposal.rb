# frozen_string_literal: true

class ClubProposal < ApplicationRecord

  #
  # Associations
  #

  belongs_to :university
  belongs_to :user

  #
  # Validations
  #

  validates :proposed_club_name, presence: true, allow_blank: false

  #
  # Methods
  #

  def approve
    return false if approved # Ensure a proposal isn't approved multiple times

    Club.transaction do
      club = create_club
      create_club_user(club, club.user)

      update(approved: true, approved_at: Time.current)
      send_approval_email
    end
  end

  def disapprove
    return false if approved # Ensure a proposal isn't disapproved multiple times

    send_disapproval_email
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

  def create_club_user(club, user)
    ClubUser.create!(club_id: club.id, user_id: user.id)
  end

  def send_approval_email
    ClubProposalMailer.with(club_proposal: self).approval_email.deliver_later
  end

  def send_disapproval_email
    ClubProposalMailer.with(club_proposal: self).disapproval_email.deliver_later
  end
end
