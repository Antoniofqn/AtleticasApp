# frozen_string_literal: true

class University < ApplicationRecord
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

  validates :name, :category, :state, :region,
            :abbreviation, :logo_url, presence: true
  validates :state, inclusion: { in: BRAZIL_STATES, message: '%<value>s não é um Estado válido' }
  validates :region, inclusion: { in: REGIONS, message: '%<value>s não é uma Região válida' }

  ##
  # Associations
  #

  has_many :clubs

  ##
  # Callbacks
  #

  after_create :set_slug

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
end
