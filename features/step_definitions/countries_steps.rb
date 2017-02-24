# frozen_string_literal: true
Then /^I should have one country$/ do
  Country.all.size.should == 1
end

Then /^I should have country for (.+)$/ do |country_name|
  return true if Country.find_by(name: country_name)
end

Then /^I should have zero countries$/ do
  Country.all.reload.size.should.zero?
end

Given /^country$/ do
  FactoryGirl.create(:country, name: 'Australia', iso: 'AUS')
end
