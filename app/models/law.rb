# frozen_string_literal: true
# == Schema Information
#
# Table name: laws
#
#  id            :integer          not null, primary key
#  country_id    :integer
#  vpa_indicator :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Law < ApplicationRecord
  translates :legal_reference, :legal_penalty

  belongs_to :country, inverse_of: :laws

  has_many :annex_operators, inverse_of: :law

  validates :legal_reference, presence: true

  scope :by_legal_reference_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('law_translations.legal_reference ASC')
  }

  class << self
    def fetch_all(options)
      laws = by_legal_reference_asc
      laws
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
