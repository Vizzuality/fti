# frozen_string_literal: true
# == Schema Information
#
# Table name: observers
#
#  id            :integer          not null, primary key
#  observer_type :string           not null
#  country_id    :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Observer < ApplicationRecord
  translates :name, :organization

  belongs_to :country, inverse_of: :observers, optional: true

  has_many :observations, inverse_of: :observer

  validates :name, presence: true
  validates :observer_type, presence: true, inclusion: { in: %w(Mandated SemiMandated External Government),
                                                         message: "%{value} is not a valid observer type" }

  scope :by_name_asc, -> {
    includes(:translations).with_translations(I18n.available_locales)
                           .order('observer_translations.name ASC')
  }

  class << self
    def fetch_all(options)
      observers = by_name_asc
      observers
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
