# frozen_string_literal: true

class University < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search,
                  against: [:name, :abbreviation, :state, :region],
                  using: {
                    tsearch: { prefix: true }
                  }

  ##
  # Constants
  #

  BRAZIL_STATES = [
    'Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia', 'Ceará', 'Distrito Federal', 'Espírito Santo',
    'Goiás', 'Maranhão', 'Mato Grosso', 'Mato Grosso do Sul', 'Minas Gerais', 'Pará', 'Paraíba',
    'Paraná', 'Pernambuco', 'Piauí', 'Rio de Janeiro', 'Rio Grande do Norte', 'Rio Grande do Sul',
    'Rondônia', 'Roraima', 'Santa Catarina', 'São Paulo', 'Sergipe', 'Tocantins'
  ].freeze

  REGIONS = %w[Norte Nordeste Centro-Oeste Sudeste Sul].freeze

  ##
  # Validations
  #

  validates :name, :category, :state,
            :abbreviation, presence: true
  validates :state, inclusion: { in: BRAZIL_STATES, message: '%<value>s não é um Estado válido' }

  ##
  # Associations
  #

  has_many :clubs

  ##
  # Callbacks
  #

  after_create :set_slug
  before_validation :set_region

  ##
  # Enumerators
  #

  enum category: { public: 0, private: 1 }, _prefix: :category

  ##
  # Methods
  #

  def set_slug
    update(slug: name.strip.parameterize)
  end

  def set_region
    self.region = case state
                  when 'Acre', 'Amapá', 'Amazonas', 'Pará', 'Rondônia', 'Roraima', 'Tocantins'
                    'Norte'
                  when 'Alagoas', 'Bahia', 'Ceará', 'Maranhão', 'Paraíba', 'Pernambuco',
                      'Piauí', 'Rio Grande do Norte', 'Sergipe'
                    'Nordeste'
                  when 'Distrito Federal', 'Goiás', 'Mato Grosso', 'Mato Grosso do Sul'
                    'Centro-Oeste'
                  when 'Espírito Santo', 'Minas Gerais', 'Rio de Janeiro', 'São Paulo'
                    'Sudeste'
                  when 'Paraná', 'Rio Grande do Sul', 'Santa Catarina'
                    'Sul'
                  end
  end
end
