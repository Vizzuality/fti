# frozen_string_literal: true
Then /^I should have one observation$/ do
  Observation.count == 1
end

Then /^I should have observation for (.+)$/ do |observation_name|
  # return true if Observation.find_by()
end

Then /^I should have zero observations$/ do
  Observation.count.zero?
end

Given /^observation$/ do
  FactoryGirl.create(:observation_1)
end
