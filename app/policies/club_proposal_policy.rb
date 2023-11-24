# frozen_string_literal: true

##
# Club's Proposal controller policies
#
class ClubProposalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none unless user

      scope.where(id: user.club_proposals.pluck(:id))
    end
  end

  def show?
    raise_error _and(user_owns_record?)
  end

  def create?
    true
  end

  def index?
    true
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def user_owns_record?
    user.id == record.user_id ? true : __method__
  end
end
