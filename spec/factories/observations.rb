# == Schema Information
#
# Table name: observations
#
#  id                  :integer          not null, primary key
#  annex_operator_id   :integer
#  annex_governance_id :integer
#  severity_id         :integer
#  observation_type    :string           not null
#  user_id             :integer
#  publication_date    :datetime
#  country_id          :integer
#  observer_id         :integer
#  operator_id         :integer
#  government_id       :integer
#  pv                  :string
#  active              :boolean          default(TRUE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :observation_1, class: 'Observation' do
    observation_type 'AnnexOperator'
    active            true
    evidence         'Lorem ipsum..'
    publication_date DateTime.now.to_date
    association :country, factory: :country

    after(:create) do |observation|
      annex = FactoryGirl.create(:annex_operator)

      observation.update(severity: FactoryGirl.create(:severity, severable: annex),
                         annex_operator: annex,
                         user: FactoryGirl.create(:admin),
                         observer: FactoryGirl.create(:observer, name: "Observer #{Faker::Lorem.sentence}"),
                         operator: FactoryGirl.create(:operator, name: "Operator #{Faker::Lorem.sentence}"),
                         species: [FactoryGirl.create(:species)])
    end
  end

  factory :observation_2, class: 'Observation' do
    observation_type 'AnnexGovernance'
    active            true
    evidence         'Lorem ipsum..'
    publication_date (DateTime.now - 1.days).to_date
    association :country, factory: :country

    after(:create) do |observation|
      annex = FactoryGirl.create(:annex_governance)

      observation.update(severity: FactoryGirl.create(:severity, severable: annex),
                         annex_governance: annex,
                         user: FactoryGirl.create(:admin),
                         observer: FactoryGirl.create(:observer, name: "Observer #{Faker::Lorem.sentence}"),
                         government: FactoryGirl.create(:government),
                         species: [FactoryGirl.create(:species, name: "Species #{Faker::Lorem.sentence}")])
    end
  end
end
