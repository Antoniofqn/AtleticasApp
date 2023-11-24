# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  ##
  # Validations
  #

  validates :email, uniqueness: true, if: -> { email.present? }
  validates :password, presence: true, allow_blank: false, on: :create
  validates :password, confirmation: true, if: -> { password.present? }
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validates :first_name, presence: true, allow_blank: false
  validates :last_name, presence: true, allow_blank: false

  ##
  # Associations
  #

  has_many :club_users
  has_many :clubs, through: :club_users
  has_many :club_proposals

  ##
  # Callbacks
  #

  before_validation :set_uid, on: :create

  ##
  # Methods
  #

  def set_uid
    self.uid = email if uid.blank? && email.present?
  end

  def name
    "#{first_name} #{last_name}"
  end
end
