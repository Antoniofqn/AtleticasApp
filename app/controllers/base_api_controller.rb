class BaseApiController < ActionController::API
  include ActionController::Helpers
  include ApplicationHelper
  # Authenticate before every action.
  before_action :filter_order_params, except: %i[generate_presigned_aws_url]

  # Respond to / with JSON messaging.
  respond_to :json

  ###
  # Define default api fallback
  #
  def fallback_index_html
    render file: 'public/index.html'
  end

  ##
  # This endpoint uses the helper method located in application helper
  # to return a presigned aws url for image upload purposes
  #
  def generate_presigned_aws_url
    return bad_request(I18n.t('api.errors.file_name_blank')) unless params[:file_name]

    # the following method returning the url is in the application helper
    @url = presigned_aws_url(params[:file_name])
    render 'api/presigned_aws_url'
  end

  ##
  # Provide unauthorized JSON response if user is not permitted
  # to conduct certain actions
  #
  rescue_from Pundit::NotAuthorizedError do |exception|
    begin
      message = JSON.parse(exception.message)
    rescue JSON::ParserError => e
      message = []
    end
    forbidden(message || [])
  end

  ##
  # Provide not_found JSON response if necessary
  #
  rescue_from ActiveRecord::RecordNotFound do |exception|
    not_found(exception.model, exception.id)
  end

  private

  ##
  # Skip action
  #
  def skip_action?
    @skip_action
  end

  ##
  # If a record fails validation or otherwise cannot be created, fail with
  # a bad request (400) HTTP Status Code.
  #
  def bad_request(errors = nil)
    @errors = errors&.flatten&.map{ |error|
                error.present? && error.respond_to?(:slice) ? error.slice(0, 1).upcase << (error.slice(1..-1) || '') : error
              }&.uniq
    @errors = [I18n.t('api.errors.bad_request')] if @errors.blank?
    render 'api/error', status: :bad_request
  end

  ##
  # Quick response of not found for empty record sets.
  #
  def not_found(model = nil, id = nil)
    model = I18n.t("activerecord.models.#{model.present? ? model.underscore : 'default'}.one").capitalize
    id = id.present? ? " (id: #{id})" : ''
    @errors = [I18n.t('api.errors.not_found', model: model, id: id)]
    render 'api/error', status: :not_found
  end

  ##
  # Quick response for authentication failures.
  #
  def unauthorized(errors = nil, code = nil)
    @errors = (errors || [I18n.t('api.errors.unauthorized')]).uniq
    @code = code
    render 'api/error', status: :unauthorized
  end

  ##
  # Quick response for authentication failures.
  #
  def forbidden(*errors)
    @errors = (errors.flatten.present? ? errors : [I18n.t('api.errors.forbidden')]).flatten.uniq
    render 'api/error', status: :forbidden
  end

  ##
  # Show available information from controller
  #
  def info(data)
    @data = data
    render 'api/info', status: 200
  end


  ##
  # Default meta for serialized json
  #
  def serializer_meta(object, query, extra_params = {})
    { total_pages: object.total_pages,
      current_page: object.current_page,
      count: query.count }.merge(extra_params)
  end

  protected

  ##
  # Set pagination params to default value if they are not passed
  #
  def set_default_pagination_params
    params[:per_page] ||= @q&.size&.positive? ? @q.size : 1
    params[:page] ||= 1
    params
  end

  ##
  # Filter params used on indexes
  #
  def filter_order_params
    if scope.present? && scope.column_names.include?(params[:sort_by]&.to_s&.downcase) &&
        %w[asc desc].include?(params[:order_by]&.to_s&.downcase)
      return
    end

    params[:sort_by] = 'created_at'
    params[:order_by] = 'asc'
  end

  ##
  # Define index scope
  #
  def scope
    model = model_from_controller(self.class)
    return model if model

    custom_scope_method_name = "#{controller_name}_scope"
    respond_to?(custom_scope_method_name, true) ? send(custom_scope_method_name) : nil
  end
end
