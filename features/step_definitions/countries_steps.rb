# frozen_string_literal: true
Then /^I should have one country$/ do
  Country.count == 1
end

Then /^I should have country for (.+)$/ do |country_name|
  return true if Country.find_by(name: country_name)
end

Then /^I should have zero countries$/ do
  Country.count.zero?
end

Given /^country$/ do
  FactoryGirl.create(:country, name: 'Australia', iso: 'AUS')
end
