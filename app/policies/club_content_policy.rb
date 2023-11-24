# frozen_string_literal: true

##
# Club's controller policies
#
class ClubContentPolicy < ApplicationPolicy

  def create?
    true
    # raise_error _and(user_belongs_to_records_club?)
  end

  def update?
    true
    # raise_error _and(user_belongs_to_records_club?)
  end

  def destroy?
    true
    # raise_error _and(user_belongs_to_records_club?)
  end
end
