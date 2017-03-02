# frozen_string_literal: true
Then /^I should have one government$/ do
  Government.count == 1
end

Then /^I should have government for (.+)$/ do |government_name|
  return true if Government.find_by(government_entity: government_name)
end

Then /^I should have zero governments$/ do
  Government.count.zero?
end

Given /^government$/ do
  FactoryGirl.create(:government, government_entity: 'Government')
end
