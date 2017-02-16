# == Schema Information
#
# Table name: annex_governances
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :annex_governance do
    governance_pilar   'Annex governance pilar'
    governance_problem 'Governence problem'
    details            'Lorem ipsum..'
  end
end
