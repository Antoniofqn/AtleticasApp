# frozen_string_literal: true

class Club < ApplicationRecord
  ##
  # Validations
  #

  validates :name, presence: true, allow_blank: false

  #
  # Associations
  #

  belongs_to :university
  has_many :club_users
  has_many :users, through: :club_users

  #
  # Callbacks
  #

  after_create :set_slug

  ##
  # Methods
  #

  def set_slug
    update(slug: name.strip.parameterize)
  end
end