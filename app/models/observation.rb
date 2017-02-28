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

  validates :country_id,       presence: true, if: 'form_step.blank?'
  validates :observation_type, presence: true, inclusion: { in: %w(AnnexGovernance AnnexOperator),
                                                            message: "%{value} is not a valid observation type" }, if: 'form_step.blank?'
  validate :step_validation,   unless: 'form_step.blank?'

  attr_accessor :form_step

  cattr_accessor :form_steps do
    [{ page: 'types', name: 'Types', params: %w[observation_type country_id] },
     { page: 'info', name: 'Info',
       params: %w[annex_governance_id government_id annex_operator_id pv concern_opinion litigation_status
                  observer_id operator_id observation_type publication_date country_id
                  active details evidence severity_id] },
     { page: 'attachments', name: 'Attachments', params: %w[documents_attributes photos_attributes] }]
  end

  scope :by_date_desc,  -> { includes(:translations).order('observations.publication_date DESC') }
  scope :by_governance, -> { where(observation_type: 'AnnexGovernance')                          }
  scope :by_operator,   -> { where(observation_type: 'AnnexOperator')                            }

  class << self
    def fetch_all(options)
      observations = by_date_asc.includes(:severity, :documents, :photos,
                                          { severity: :translations }, :annex_operator,
                                          { annex_operator: :translations }, :annex_governance,
                                          { annex_governance: :translations })
      observations
    end

    def types
      %w(AnnexGovernance AnnexOperator).freeze
    end

    def translated_types
      types.map { |t| [I18n.t("observation_types.#{t}", default: t), t.camelize] }
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

  def title
    severity.try(:severable).try(:illegality) || severity.try(:severable).try(:governance_pillar)
  end

  def law
    severity.try(:severable).try(:law)
  end

  def user_name
    self.try(:user).try(:name)
  end

  def translated_type
    I18n.t("observation_types.#{observation_type.constantize}")
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

  private

    def step_validation
      step_order = form_steps.map{|x| x[:page]}
      step_index = step_order.index(form_step)

      if step_index.nil?
        self.errors['form_step'] << 'Step not defined'
        return
      end

      if step_index >= step_order.index('types')
        self.errors['country_id'] << 'You must select a country' if self.country_id.blank?
        self.errors['observation_type'] << 'You must select a valid observation type' if
            self.observation_type.blank? || %w(AnnexGovernance AnnexOperator).exclude?(self.observation_type)
      end
      if step_index >= step_order.index('info')

        if observation_type == 'AnnexGovernance'
          self.errors['annex_governance_id'] << 'You must select a governance' if self.annex_governance_id.blank?
        else
          self.errors['annex_operator_id'] << 'You must select an operator' if self.annex_operator_id.blank?
          self.errors['operator_id'] << 'You must select an operator' if self.operator_id.blank?
        end

        self.errors['observer_id'] << 'You must select an observer' if self.observer_id.blank?
        self.errors['publication_date'] << 'You must select a publication date' if self.publication_date.blank?
        #self.errors['severity_id'] << 'You must select a severity' if self.severity_id.blank?

      end
      if step_index >= step_order.index('attachments')

      end
    end
end
