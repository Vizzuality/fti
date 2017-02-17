# frozen_string_literal: true
# == Schema Information
#
# Table name: operators
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  operator_type :string
#  country_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Operator < ApplicationRecord
  translates :name, :details

  belongs_to :country, inverse_of: :operators, optional: true

  has_many :observations, inverse_of: :operator

  validates :name, presence: true

  scope :by_name_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('operator_translations.name ASC')
  }

  class << self
    def fetch_all(options)
      operators = by_name_asc
      operators
    end

    def operator_select
      by_name_asc.map { |c| [c.name, c.id] }
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
