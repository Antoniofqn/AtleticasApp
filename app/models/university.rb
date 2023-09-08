# frozen_string_literal: true

class University < ApplicationRecord
  ##
  # Validations
  #

  validates :name, :category, :state, :region,
            :abbreviation, :logo_url, presence: true
  ##
  # Associations
  #

  ##
  # Callbacks
  #

  after_create :set_slug

  ##
  # Enumerators
  #

  enum category: { public: 0, private: 1 }, _prefix: :category

  ##
  # Methods
  #

  def set_slug
    update(slug: name.strip.parameterize)
  end
end
