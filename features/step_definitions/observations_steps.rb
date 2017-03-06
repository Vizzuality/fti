# frozen_string_literal: true
Then /^I should have one observation$/ do
  Observation.count == 1
end

Then /^I should have observation for (.+)$/ do |observation_name|
  return true if Observation.find_by(evidence: observation_name)
end

Then /^I should have zero observations$/ do
  Observation.count.zero?
end

Given /^observation$/ do
  FactoryGirl.create(:observation_1)
end

Given /^observation governance$/ do
  FactoryGirl.create(:observation_2)
end

Given /^observation matched annex_operator$/ do
  FactoryGirl.create(:country, active: true)
  FactoryGirl.create(:annex_operator, illegality: 'Illegality two', country_id: Country.last.id)
  FactoryGirl.create(:severity, level: 2, details: 'Lorem ipsum..', severable: AnnexOperator.last)
  FactoryGirl.create(:observation_1, evidence: 'Operator observation', country_id: AnnexOperator.last.country.id)
end
