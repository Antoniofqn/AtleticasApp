# frozen_string_literal: true

##
# Universities's controller policies
#
class UniversityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end
end
