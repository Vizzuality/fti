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
  translates :name, :region_name, fallbacks_for_empty_translations: true

  has_many :users, inverse_of: :country

  class << self
    def country_select(current_locale)
      with_translations(current_locale.to_s).order('country_translations.name ASC')
                                            .map { |c| [c.name, c.id] }
    end
  end
end
