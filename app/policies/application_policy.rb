class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def user_present?
    user.present? && user.id.present? ? true : __method__
  end

  def user_belongs_to_records_club?
    record.club.users.include?(user) ? true : __method__
  end

  def _or *options
    truths = options.flatten.select { |o| o == true }
    errors = options.flatten.reject { |o| o == true }
    truths.present? ? truths : errors
  end

  def _and *options
    errors = options.flatten.reject { |o| o == true }
    errors.present? ? errors : [true]
  end

  def raise_error errors
    return true if errors.flatten.reject { |o| o == true }.blank?
    return false if Rails.env == 'test' && errors.flatten.reject { |o| o == true }.present?

    error_messages = errors.map { |o| I18n.t("pundit.errors.#{o.to_s}") }
    raise Pundit::NotAuthorizedError, message: error_messages
  end
end
