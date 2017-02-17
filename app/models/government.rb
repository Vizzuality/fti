# frozen_string_literal: true
# == Schema Information
#
# Table name: governments
#
#  id         :integer          not null, primary key
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Government < ApplicationRecord
  translates :name, :government_entity, :details

  belongs_to :country, inverse_of: :governments, optional: true

  has_many :observations, inverse_of: :government

  validates :name, presence: true

  scope :by_name_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('government_translations.name ASC')
  }

  class << self
    def fetch_all(options)
      governments = by_name_asc
      governments
    end

    def entity_select
      by_name_asc.map { |c| [c.name, c.id] }
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
