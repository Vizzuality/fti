# frozen_string_literal: true
# == Schema Information
#
# Table name: severities
#
#  id             :integer          not null, primary key
#  level          :integer
#  severable_id   :integer          not null
#  severable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Severity < ApplicationRecord
  translates :details

  belongs_to :severable, polymorphic: true
  belongs_to :annex_governance, foreign_key: :severable_id
  belongs_to :annex_operator,   foreign_key: :severable_id

  has_many :observations, inverse_of: :severity
  has_many :comments,     as: :commentable

  validates :details, presence: true

  validates_presence_of   :level
  validates_uniqueness_of :level, scope: [:severable_type, :severable_id]

  scope :by_level_asc, -> {
    includes(:translations).order('severities.level ASC')
  }

  class << self
    def fetch_all(options)
      severities = by_level_asc
      severities
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
