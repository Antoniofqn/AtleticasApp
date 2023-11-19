# frozen_string_literal: true

##
# Club's controller policies
#
class ClubHonorPolicy < ApplicationPolicy

  def create?
    raise_error _and(user_belongs_to_records_club?)
  end

  def update?
    raise_error _and(user_belongs_to_records_club?)
  end

  def destroy?
    raise_error _and(user_belongs_to_records_club?)
  end
end
