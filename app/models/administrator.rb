# frozen_string_literal: true

##
# Admin authentication is managed by Devise.
# Admin dashboard is managed by Adminstrate.
class Administrator < ApplicationRecord

  #
  # Devise
  #

  devise :database_authenticatable, :rememberable, :validatable

  #
  # Validation
  #

  validates :email, uniqueness: true
  validates :password, confirmation: true, allow_blank: false
end
