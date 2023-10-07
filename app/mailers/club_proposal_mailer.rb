# frozen_string_literal: true

class ClubProposalMailer < ApplicationMailer
  def approval_email(club_proposal)
    @club_proposal = club_proposal
    @club = Club.find_by(name: @club_proposal.proposed_club_name)
    @user = User.find_by(email: @club_proposal.user)
    mail(to: @user.email, subject: 'Sua proposta foi aprovada!')
  end

  def disapproval_email(club_proposal)
    @club_proposal = club_proposal
    mail(to: @club_proposal.user.email, subject: 'Sua proposta foi negada.')
  end
end
