# frozen_string_literal: true

##
# Manage all mopdels on
#
class ApplicationRecord < ActiveRecord::Base
  include ActiveModel::Validations
  include ApplicationHelper
  include Hashid::Rails
  extend ApplicationHelper
  self.abstract_class = true

  #
  # Constants
  #

  API_SEARCHABLE_FIELDS = [].freeze

  #
  # Virtual attributes
  #

  attr_accessor :changed_by_user

  ##
  # Function to add belongs to hashids to model
  #
  def self.belongs_to_associated_hashids
    reflect_on_all_associations(:belongs_to).each do |klass|
      define_method :"#{klass.name.to_s.singularize}_hashid" do
        send(klass.name)&.hashid
      end
      define_method :"#{klass.name.to_s.singularize}_hashid=" do |value|
        send("#{klass.name.to_s.singularize}_id=", klass.klass.decode_id(value))
      end
    end
  end

  ##
  # Function to add has one hashids to model
  #
  def self.has_one_associated_hashids
    reflect_on_all_associations(:has_one).each do |klass|
      define_method :"#{klass.name.to_s.singularize}_hashid" do
        send(klass.name)&.hashid
      end
    end
  end

  ##
  # Function to add has many hashids to model
  #
  def self.has_many_associated_hashids
    reflect_on_all_associations(:has_many).each do |klass|
      define_method :"#{klass.name.to_s.singularize}_hashids" do
        send(klass.name)&.map(&:hashid)
      end
    end
  end

  ##
  # Get translated attribute
  #
  def self.locale_key(attribute)
    return nil unless attribute.present? && (column_names.include?(attribute.to_s) || method_defined?(attribute))

    I18n.t("activerecord.attributes.#{name.underscore}.#{attribute}")
  end

  ##
  # Get translated attribute
  #
  def locale_key(attribute)
    self.class.locale_key(attribute)
  end

  ##
  # Get translated value
  #
  def locale_value(attribute)
    return nil unless attribute.present? && respond_to?(attribute)

    send(attribute)
  end

  ##
  # Titleize fields
  #
  def titleize_fields(fields = [])
    return self if fields.blank?

    fields.each do |field|
      next unless send(field).is_a?(String)

      send("#{field}=", send(field).titleize)
    end
    self
  end

  ##
  # Add an instance method to application_record.rb / active_record.rb
  #
  def all_blank?(attributes)
    attributes.all? do |key, value|
      key == '_destroy' || value.blank? || value.is_a?(Hash) && all_blank?(value)
    end
  end
end
