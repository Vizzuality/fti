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
  translates :governance_pilar, :governance_problem, :details

  has_many :severities,   as: :severable
  has_many :categorings,  as: :categorizable
  has_many :categories,   through: :categorings
  has_many :comments,     as: :commentable
  has_many :observations, inverse_of: :annex_governance

  validates :governance_pilar, presence: true

  accepts_nested_attributes_for :severities,  allow_destroy: true
  accepts_nested_attributes_for :categorings, allow_destroy: true

  scope :by_governance_pilar_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('annex_governance_translations.governance_pilar ASC')
  }

  class << self
    def fetch_all(options)
      annex_governances = by_governance_pilar_asc
      annex_governances
    end

    def governance_pilar_select
      by_governance_pilar_asc.map { |gp| [gp.governance_pilar, gp.id] }
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
