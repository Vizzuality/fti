# == Schema Information
#
# Table name: observations
#
#  id               :integer          not null, primary key
#  severity_id      :integer
#  observation_type :string           not null
#  user_id          :integer
#  publication_date :datetime
#  country_id       :integer
#  observer_id      :integer
#  operator_id      :integer
#  government_id    :integer
#  active           :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :observation_1, class: 'Observation' do
    observation_type 'AnnexOperator'
    active            true
    evidence         'Lorem ipsum..'
    publication_date DateTime.now.to_date

    after(:create) do |observation|
      annex = FactoryGirl.create(:annex_operator)

      observation.update(country: FactoryGirl.create(:country),
                         severity: FactoryGirl.create(:severity, severable: annex),
                         user: FactoryGirl.create(:admin),
                         observer: FactoryGirl.create(:observer),
                         operator: FactoryGirl.create(:operator),
                         species: [FactoryGirl.create(:species)])
    end
  end

  factory :observation_2, class: 'Observation' do
    observation_type 'AnnexGovernance'
    active            true
    evidence         'Lorem ipsum..'
    publication_date (DateTime.now - 1.days).to_date

    after(:create) do |observation|
      annex = FactoryGirl.create(:annex_governance)

      observation.update(country: FactoryGirl.create(:country),
                         severity: FactoryGirl.create(:severity, severable: annex),
                         user: FactoryGirl.create(:admin),
                         observer: FactoryGirl.create(:observer),
                         government: FactoryGirl.create(:government),
                         species: [FactoryGirl.create(:species)])
    end
  end
end
