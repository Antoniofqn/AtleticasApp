require 'rails_helper'

RSpec.describe University, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:region) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:abbreviation) }
  end

  describe 'associations' do
    it { should have_many(:clubs) }
  end

  describe 'callbacks' do
    it 'should set slug after create' do
      university = create(:university, name: 'University of Lagos')
      expect(university.slug).to eq('university-of-lagos')
    end
  end

  describe 'enumerators' do
    it 'should have prefixed methods for category enum' do
      university = University.new
      university.category = 'public'
      expect(university).to be_category_public
      expect(university).not_to be_category_private
    end
  end

  describe 'methods' do
    it 'should set slug' do
      university = create(:university, name: 'University of Lagos')
      expect(university.slug).to eq('university-of-lagos')
    end
  end
end
