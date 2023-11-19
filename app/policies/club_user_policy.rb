# frozen_string_literal: true

##
# Club Users's controller policies
#
class ClubUserPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.none unless user

      scope.where(club_id: user.clubs.pluck(:id))
    end
  end

  def create?
    raise_error _and(user_belongs_to_same_club_as_club_user?, club_user_already_exists?)
  end

  def destroy?
    raise_error _and(user_belongs_to_same_club_as_club_user?)
  end

  private

  def user_belongs_to_same_club_as_club_user?
    record.club.users.include?(user) ? true : __method__
  end

  def club_user_already_exists?
    record.club.users.include?(record.user) ? __method__ : true
  end
end
