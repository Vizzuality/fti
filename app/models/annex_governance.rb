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
  translates :governance_pillar, :governance_problem, :details

  before_create :check_validations

  has_many :severities,   as: :severable
  has_many :categorings,  as: :categorizable
  has_many :categories,   through: :categorings
  has_many :comments,     as: :commentable
  has_many :observations, inverse_of: :annex_governance

  validates :governance_pillar,  presence: true
  validates :governance_problem, presence: true

  accepts_nested_attributes_for :severities,  allow_destroy: true
  accepts_nested_attributes_for :categorings, allow_destroy: true

  scope :by_governance_problem_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('annex_governance_translations.governance_problem ASC')
  }

  class << self
    def fetch_all(options)
      annex_governances = by_governance_problem_asc
      annex_governances
    end

    def governance_problem_select
      by_governance_problem_asc.map { |gp| [gp.governance_problem, gp.id] }
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

  private

    def check_validations
      self.governance_pillar  = 'Not specified' unless self.governance_pillar.present?
      self.governance_problem = 'Not specified' unless self.governance_problem.present?
    end
end
