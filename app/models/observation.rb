# frozen_string_literal: true
# == Schema Information
#
# Table name: observations
#
#  id                  :integer          not null, primary key
#  annex_operator_id   :integer
#  annex_governance_id :integer
#  severity_id         :integer
#  observation_type    :string           not null
#  user_id             :integer
#  publication_date    :datetime
#  country_id          :integer
#  observer_id         :integer
#  operator_id         :integer
#  government_id       :integer
#  pv                  :string
#  active              :boolean          default(TRUE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Observation < ApplicationRecord
  translates :details, :evidence, :concern_opinion, :litigation_status

  belongs_to :country,    inverse_of: :observations
  belongs_to :observer,   inverse_of: :observations, optional: true
  belongs_to :severity,   inverse_of: :observations
  belongs_to :operator,   inverse_of: :observations, optional: true
  belongs_to :government, inverse_of: :observations, optional: true
  belongs_to :user,       inverse_of: :observations, optional: true

  belongs_to :annex_operator,   inverse_of: :observations, optional: true
  belongs_to :annex_governance, inverse_of: :observations, optional: true

  has_many :species_observations
  has_many :species, through: :species_observations

  has_many :comments,  as: :commentable
  has_many :photos,    as: :attacheable, dependent: :destroy
  has_many :documents, as: :attacheable, dependent: :destroy

  accepts_nested_attributes_for :photos,           allow_destroy: true
  accepts_nested_attributes_for :documents,        allow_destroy: true
  accepts_nested_attributes_for :annex_operator,   allow_destroy: true
  accepts_nested_attributes_for :annex_governance, allow_destroy: true

  validates :country_id,       presence: true
  validates :observation_type, presence: true, inclusion: { in: %w(AnnexGovernance AnnexOperator),
                                                            message: "%{value} is not a valid observation type" }

  scope :by_date_desc, -> {
    includes(:translations).order('observations.publication_date DESC')
  }

  scope :by_governance, -> { where(observation_type: 'AnnexGovernance') }
  scope :by_operator,   -> { where(observation_type: 'AnnexOperator')   }

  class << self
    def fetch_all(options)
      observations = by_date_asc.includes(:severity, :documents, :photos,
                                          { severity: :translations }, :annex_operator,
                                          { annex_operator: :translations }, :annex_governance,
                                          { annex_governance: :translations })
      observations
    end

    def types
      %w(AnnexGovernance AnnexOperator)
    end

    def translated_types
      types.map { |t| [I18n.t("observation_types.#{t.constantize}", default: t.constantize), t.camelize] }
    end
  end

  def is_governance?
    observation_type.include?('AnnexGovernance')
  end

  def is_operator?
    observation_type.include?('AnnexOperator')
  end

  def illegality
    severity.try(:severable).try(:illegality)
  end

  def law
    severity.try(:severable).try(:law)
  end

  def user_name
    self.try(:user).try(:name)
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
