# frozen_string_literal: true
Then /^I should have one operator$/ do
  Operator.count == 1
end

Then /^I should have operator for (.+)$/ do |operator_name|
  return true if Operator.find_by(name: operator_name)
end

Then /^I should have zero operators$/ do
  Operator.count.zero?
end

Given /^operator$/ do
  FactoryGirl.create(:operator, name: 'Operator')
end
