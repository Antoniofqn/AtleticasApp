# frozen_string_literal: true

class Club < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search,
                  against: [:name],
                  using: {
                    tsearch: { prefix: true }
                  }

  ##
  # Validations
  #

  validates :name, presence: true, allow_blank: false

  #
  # Associations
  #

  belongs_to :university
  has_many :club_users, dependent: :destroy
  has_many :users, through: :club_users
  has_many :club_honors, dependent: :destroy
  has_many :club_athletes, dependent: :destroy
  has_one :club_content, dependent: :destroy

  #
  # Callbacks
  #

  after_create :set_slug
  after_create :create_empty_content

  ##
  # Methods
  #

  def set_slug
    update(slug: name.strip.parameterize)
  end

  def create_empty_content
    ClubContent.create!(club: self, content: 'Edite a história da sua Atlética aqui.')
  end
end
