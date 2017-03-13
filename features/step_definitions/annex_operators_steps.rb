# frozen_string_literal: true
Then /^I should have one annex_operator$/ do
  AnnexOperator.count == 1
end

Then /^I should have annex_operator for (.+)$/ do |annex_operator_name|
  return true if AnnexOperator.find_by(illegality: annex_operator_name)
end

Then /^I should have zero annex_operators$/ do
  AnnexOperator.count.zero?
end

Given /^annex_operator$/ do
  @annex = FactoryGirl.create(:annex_operator, illegality: 'Illegality one')
  FactoryGirl.create(:severity, level: 2, details: 'Lorem ipsum..', severable: @annex)
end

Given /^country matched annex_operator$/ do
  FactoryGirl.create(:country, id: 5, name: 'Test Country', active: true)
  FactoryGirl.create(:annex_operator, id: 5, illegality: 'Illegality two', country_id: 5)
  FactoryGirl.create(:severity, level: 2, details: 'Lorem ipsum..', severable: AnnexOperator.find(5))
end
