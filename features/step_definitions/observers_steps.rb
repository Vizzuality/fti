# frozen_string_literal: true
Then /^I should have one monitor$/ do
  Observer.count == 1
end

Then /^I should have monitor for (.+)$/ do |monitor_name|
  return true if Observer.find_by(name: monitor_name)
end

Then /^I should have zero monitors$/ do
  Observer.count.zero?
end

Given /^monitor$/ do
  FactoryGirl.create(:observer, name: 'Monitor')
end
