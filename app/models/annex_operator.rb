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

  has_many :severities,   as: :severable
  has_many :categorings,  as: :categorizable
  has_many :categories,   through: :categorings
  has_many :comments,     as: :commentable
  has_many :observations, inverse_of: :annex_operator

  accepts_nested_attributes_for :severities,  allow_destroy: true
  accepts_nested_attributes_for :categorings, allow_destroy: true
  accepts_nested_attributes_for :law,         allow_destroy: true

  validates :illegality, presence: true

  scope :by_illegality_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('annex_operator_translations.illegality ASC')
  }

  scope :by_country, ->country_id { where('annex_operators.country_id = ?', country_id) }

  class << self
    def fetch_all(options)
      annex_operators = by_illegality_asc
      annex_operators
    end

    def illegality_select(options)
      country_id = options[:country_id]
      by_country(country_id).by_illegality_asc.map { |il| [il.illegality, il.id] }
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
