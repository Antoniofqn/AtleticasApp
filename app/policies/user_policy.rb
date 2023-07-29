# frozen_string_literal: true

##
# User's controller policies
#
class UserPolicy < ApplicationPolicy
  #
  # Actions
  #

  def create?
    true
  end

  def destroy?
    show?
  end

  def index?
    false
  end

  def update?
    show?
  end

  def show?
    raise_error _and(user_self?)
  end

  private

  ##
  # The current user must be present and the user must have an assigned ID.
  #
  def user_self?
    user.present? && record.hashid == user.hashid ? true : __method__
  end
end
