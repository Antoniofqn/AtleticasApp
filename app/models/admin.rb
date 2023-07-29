# frozen_string_literal: true

##
# Admin authentication is managed by Devise.
# Admin dashboard is managed by RailsAdmin.
class Admin < ApplicationRecord

  #
  # Devise
  #

  devise :database_authenticatable, :rememberable, :validatable

  #
  # Validation
  #

  validates :email, uniqueness: true
  validates :first_name, :last_name, :email, presence: true, allow_blank: false
  validates :password, confirmation: true, allow_blank: false

  ##
  # Get administrator name
  #
  def name
    [first_name, last_name].join(' ')
  end
end
