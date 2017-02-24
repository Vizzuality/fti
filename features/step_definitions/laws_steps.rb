# frozen_string_literal: true
Then /^I should have one law$/ do
  Law.all.size.should == 1
end

Then /^I should have law for (.+)$/ do |law_name|
  return true if Law.find_by(legal_reference: law_name)
end

Then /^I should have zero laws$/ do
  Law.all.reload.size.should.zero?
end

Given /^law$/ do
  FactoryGirl.create(:law, legal_reference: 'Law')
end
