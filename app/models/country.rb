# frozen_string_literal: true
# == Schema Information
#
# Table name: countries
#
#  id               :integer          not null, primary key
#  iso              :string
#  region_iso       :string
#  country_centroid :jsonb
#  region_centroid  :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Country < ApplicationRecord
  translates :name, :region_name

  has_many :users,           inverse_of: :country
  has_many :observations,    inverse_of: :country
  has_many :observers,       inverse_of: :country
  has_many :annex_operators, inverse_of: :country
  has_many :laws,            inverse_of: :country
  has_many :governments,     inverse_of: :country
  has_many :operators,       inverse_of: :country

  validates :name, :iso, presence: true, uniqueness: { case_sensitive: false }

  scope :by_name_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('country_translations.name ASC')
  }

  class << self
    def country_select(current_locale)
      by_name_asc.map { |c| [c.name, c.id] }
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
