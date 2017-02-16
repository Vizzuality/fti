# frozen_string_literal: true
# == Schema Information
#
# Table name: species
#
#  id           :integer          not null, primary key
#  iucn_status  :integer
#  cites_status :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Species < ApplicationRecord
  translates :common_name, :scientific_name

  has_many :species_observations
  has_many :observations, through: :species_observations

  validates :common_name, :scientific_name, presence: true

  scope :by_common_name_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('species_translations.common_name ASC')
  }

  class << self
    def fetch_all(options)
      species = by_common_name_asc
      species
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
