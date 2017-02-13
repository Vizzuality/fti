# frozen_string_literal: true
# == Schema Information
#
# Table name: countries
#
#  id               :integer          not null, primary key
#  name             :string
#  region_name      :string
#  iso              :string
#  region_iso       :string
#  country_centroid :jsonb
#  region_centroid  :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Country < ApplicationRecord
  has_many :users, inverse_of: :country

  class << self
    def country_select
      select(:id, :name).order('countries.name ASC')
                        .map { |c| [c.name, c.id] }
    end
  end
end
