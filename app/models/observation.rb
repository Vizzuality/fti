# frozen_string_literal: true
# == Schema Information
#
# Table name: observations
#
#  id               :integer          not null, primary key
#  severity_id      :integer
#  observation_type :string           not null
#  user_id          :integer
#  publication_date :datetime
#  country_id       :integer
#  observer_id      :integer
#  operator_id      :integer
#  government_id    :integer
#  active           :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Observation < ApplicationRecord
  translates :details, :evidence

  belongs_to :country,    inverse_of: :observations
  belongs_to :observer,   inverse_of: :observations
  belongs_to :severity,   inverse_of: :observations
  belongs_to :operator,   inverse_of: :observations, optional: true
  belongs_to :government, inverse_of: :observations, optional: true
  belongs_to :user,       inverse_of: :observations, optional: true

  has_many :species_observations
  has_many :species, through: :species_observations

  has_many :comments,  as: :commentable
  has_many :photos,    as: :attacheable
  has_many :documents, as: :attacheable

  validates :observation_type, presence: true, inclusion: { in: %w(AnnexGovernance AnnexOperator),
                                                            message: "%{value} is not a valid observation type" }

  scope :by_date_desc, -> {
    includes(:translations).order('observations.publication_date DESC')
  }

  class << self
    def fetch_all(options)
      observations = by_date_asc
      observations
    end
  end

  def illegality
    severity.severable.illegality
  end

  def law
    severity.severable.law
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
