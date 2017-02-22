# frozen_string_literal: true
# == Schema Information
#
# Table name: annex_governances
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AnnexGovernance < ApplicationRecord
  translates :government_entity, :governance_problem, :details

  has_many :severities,   as: :severable
  has_many :categorings,  as: :categorizable
  has_many :categories,   through: :categorings
  has_many :comments,     as: :commentable
  has_many :observations, inverse_of: :annex_governance

  validates :government_entity, presence: true

  accepts_nested_attributes_for :severities,  allow_destroy: true
  accepts_nested_attributes_for :categorings, allow_destroy: true

  scope :by_government_entity_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('annex_governance_translations.government_entity ASC')
  }

  class << self
    def fetch_all(options)
      annex_governances = by_government_entity_asc
      annex_governances
    end

    def government_entity_select
      by_government_entity_asc.map { |gp| [gp.government_entity, gp.id] }
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
