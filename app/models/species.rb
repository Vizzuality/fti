# frozen_string_literal: true
# == Schema Information
#
# Table name: species
#
#  id              :integer          not null, primary key
#  name            :string
#  species_class   :string
#  sub_species     :string
#  species_family  :string
#  species_kingdom :string
#  scientific_name :string
#  cites_status    :string
#  cites_id        :integer
#  iucn_status     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Species < ApplicationRecord
  translates :common_name

  has_many :species_observations
  has_many :species_countries
  has_many :observations, through: :species_observations
  has_many :countries,    through: :species_countries

  validates :name, presence: true

  scope :by_name_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('species.name ASC')
  }

  class << self
    def fetch_all(options)
      species = by_name_asc
      species
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
