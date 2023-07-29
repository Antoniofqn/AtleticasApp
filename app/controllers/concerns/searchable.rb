# frozen_string_literal: true

##
# Module for searcheable resources
#
module Searcheable
  ##
  # Return searched resources
  #
  def search_resources(scope_ = scope)
    if %w[OR AND].include?(params[:global_search_conjunctor]&.upcase)
      conjunctor = params[:global_search_conjunctor].upcase
    end
    conjunctor ||= 'AND'
    scope_ = exactly_query(scope_) if exactly_search_params_present?
    if conjunctor == 'AND'
      scope_ = exactly_not_query(scope_) if exactly_not_search_params_present?
      scope_ = between_query(scope_) if between_search_params_present?
      scope_ = between_not_query(scope_) if between_not_search_params_present?
    else
      scope_ = scope_.or(exactly_not_query(scope_)) if exactly_not_search_params_present?
      scope_ = scope_.or(between_query(scope_)) if between_search_params_present?
      scope_ = scope_.or(between_not_query(scope_)) if between_not_search_params_present?
    end
    scope_
  end

  ##
  # Returns exactly query
  #
  def exactly_query(scope_ = scope)
    filter_exactly_search_keys
    ApplicationQuery.exactly_query(scope_,
                                   exactly_search_params[:exactly_search_keys],
                                   exactly_search_params[:exactly_search_values],
                                   exactly_search_params[:exactly_search_conjunctor])
  end

  ##
  # Returns exactly NOT query
  #
  def exactly_not_query(scope_ = scope)
    filter_exactly_not_search_keys
    ApplicationQuery.exactly_query(scope_,
                                   exactly_not_search_params[:exactly_not_search_keys],
                                   exactly_not_search_params[:exactly_not_search_values],
                                   exactly_not_search_params[:exactly_not_search_conjunctor],
                                   where_not: true)
  end

  ##
  # Returns between query
  #
  def between_query(scope_ = scope)
    filter_between_search_keys
    ApplicationQuery.between_query(scope_,
                                   between_search_params[:between_search_keys],
                                   between_search_params[:between_search_values],
                                   between_search_params[:between_search_conjunctor])
  end

  ##
  # Returns between NOT query
  #
  def between_query_not(scope_ = scope)
    filter_between_not_search_keys
    ApplicationQuery.between_query(scope_,
                                   between_search_params[:between_not_search_keys],
                                   between_search_params[:between_not_search_values],
                                   between_search_params[:between_not_search_conjunctor],
                                   where_not: true)
  end

  ##
  # Filter exactly search keys
  #
  def filter_exactly_search_keys
    exactly_search_params[:exactly_search_keys]&.map! do |search_key|
      next unless scope::API_SEARCHABLE_FIELDS&.include?(search_key)

      search_key
    end
  end

  ##
  # Filter exactly NOT search keys
  #
  def filter_exactly_not_search_keys
    exactly_not_search_params[:exactly_not_search_keys]&.map! do |search_key|
      next unless scope::API_SEARCHABLE_FIELDS&.include?(search_key)

      search_key
    end
  end

  ##
  # Filter between search keys
  #
  def filter_between_search_keys
    between_search_params[:between_search_keys]&.map! do |search_key|
      next unless scope::API_SEARCHABLE_FIELDS&.include?(search_key)

      search_key
    end
  end

  ##
  # Filter between NOT search keys
  #
  def filter_between_not_search_keys
    between_not_search_params[:between_not_search_keys]&.map! do |search_key|
      next unless scope::API_SEARCHABLE_FIELDS&.include?(search_key)

      search_key
    end
  end

  ##
  # Permitted params for exactly search
  #
  def exactly_search_params
    params.permit(:exactly_search_conjunctor, exactly_search_keys: [], exactly_search_values: [])
  end

  def exactly_search_params_present?
    params[:exactly_search_keys].present? && params[:exactly_search_values].present?
  end

  ##
  # Permitted params for exactly not search
  #
  def exactly_not_search_params
    params.permit(:exactly_not_search_conjunctor, exactly_not_search_keys: [], exactly_not_search_values: [])
  end

  def exactly_not_search_params_present?
    params[:exactly_not_search_keys].present? && params[:exactly_not_search_values].present?
  end

  ##
  # Permitted params for between search
  #
  def between_search_params
    params.permit(:between_search_conjunctor, between_search_keys: [], between_search_values: [])
  end

  def between_search_params_present?
    params[:between_search_keys].present? && params[:between_search_values].present?
  end


  ##
  # Permitted params for between search
  #
  def between_not_search_params
    params.permit(:between_not_search_conjunctor, between_not_search_keys: [], between_not_search_values: [])
  end

  def between_not_search_params_present?
    params[:between_not_search_keys].present? && params[:between_not_search_values].present?
  end
end
