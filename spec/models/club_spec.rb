require 'rails_helper'

RSpec.describe Club, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:club_users) }
  end

  describe 'callbacks' do
    it 'should set slug after create' do
      club = create(:club, name: 'Club of Lagos')
      expect(club.slug).to eq('club-of-lagos')
    end
  end

  describe 'methods' do
    it 'should set slug' do
      club = create(:club, name: 'Club of Lagos')
      expect(club.slug).to eq('club-of-lagos')
    end
  end
end
