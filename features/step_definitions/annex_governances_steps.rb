# frozen_string_literal: true
Then /^I should have one annex_governance$/ do
  AnnexGovernance.count == 1
end

Then /^I should have annex_governance for (.+)$/ do |annex_governance_name|
  return true if AnnexGovernance.find_by(governance_problem: annex_governance_name)
end

Then /^I should have zero annex_governances$/ do
  AnnexGovernance.count.zero?
end

Given /^annex_governance$/ do
  FactoryGirl.create(:annex_governance, governance_problem: 'Problem one')
end
