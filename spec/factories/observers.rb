# == Schema Information
#
# Table name: observers
#
#  id            :integer          not null, primary key
#  observer_type :string           not null
#  country_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :observer do
    name          'Observer'
    observer_type 'External'
  end
end
