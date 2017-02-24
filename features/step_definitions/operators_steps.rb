# frozen_string_literal: true
Then /^I should have one operator$/ do
  Operator.all.size.should == 1
end

Then /^I should have operator for (.+)$/ do |operator_name|
  return true if Operator.find_by(name: operator_name)
end

Then /^I should have zero countries$/ do
  Operator.all.reload.size.should.zero?
end

Given /^operator$/ do
  FactoryGirl.create(:operator, name: 'Operator')
end
