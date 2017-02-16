# frozen_string_literal: true
# == Schema Information
#
# Table name: annex_operators
#
#  id         :integer          not null, primary key
#  country_id :integer
#  law_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AnnexOperator < ApplicationRecord
  translates :illegality, :details

  belongs_to :country, inverse_of: :annex_operators
  belongs_to :law,     inverse_of: :annex_operators

  has_many :severities,  as: :severable
  has_many :categorings, as: :categorizable
  has_many :categories,  through: :categorings
  has_many :comments,    as: :commentable

  validates :illegality, presence: true

  scope :by_illegality_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('annex_operator_translations.illegality ASC')
  }

  class << self
    def fetch_all(options)
      annex_operators = by_illegality_asc
      annex_operators
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
