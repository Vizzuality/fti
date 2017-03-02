# frozen_string_literal: true
Then /^I should have one law$/ do
  Law.count == 1
end

Then /^I should have law for (.+)$/ do |law_name|
  return true if Law.find_by(legal_reference: law_name)
end

Then /^I should have zero laws$/ do
  Law.count.zero?
end

Given /^law$/ do
  FactoryGirl.create(:law, legal_reference: 'Law')
end
