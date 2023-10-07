require 'rails_helper'

RSpec.describe ClubProposal, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:proposed_club_name) }
  end

  describe 'associations' do
    it { should belong_to(:university) }
    it { should belong_to(:user) }
  end

  describe 'methods' do
    describe '#approve' do
      it 'should return false if approved is true' do
        club_proposal = create(:club_proposal, approved: true)
        expect(club_proposal.approve).to eq(false)
      end

      it 'should create a club, user and club_user' do
        club_proposal = create(:club_proposal)
        expect(club_proposal.approve).to eq(true)
        expect(Club.count).to eq(1)
        expect(User.count).to eq(1)
        expect(ClubUser.count).to eq(1)
      end
    end
  end
end
