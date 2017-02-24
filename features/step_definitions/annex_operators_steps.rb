# frozen_string_literal: true
Then /^I should have one annex_operator$/ do
  AnnexOperator.all.size.should == 1
end

Then /^I should have annex_operator for (.+)$/ do |annex_operator_name|
  return true if AnnexOperator.find_by(illegality: annex_operator_name)
end

Then /^I should have zero annex_operators$/ do
  AnnexOperator.all.reload.size.should.zero?
end

Given /^annex_operator$/ do
  FactoryGirl.create(:annex_operator, illegality: 'Illegality one')
end
