# frozen_string_literal: true
Then /^I should have one species$/ do
  Species.count == 1
end

Then /^I should have species for (.+)$/ do |species_name|
  return true if Species.find_by(name: species_name)
end

Then /^I should have zero species$/ do
  Species.count.zero?
end

Given /^species$/ do
  FactoryGirl.create(:species, name: 'Red resurrexit', common_name: 'Rote rose')
end
