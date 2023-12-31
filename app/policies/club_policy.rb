# frozen_string_literal: true

##
# Club's controller policies
#
class ClubPolicy < ApplicationPolicy

  def create?
    true
  end

  def update?
    true
    #raise_error _and(user_belongs_to_club?)
  end

  private

  def user_belongs_to_club?
    record.users.include?(user) ? true : __method__
  end
end
