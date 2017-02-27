# frozen_string_literal: true
Then /^I should have one monitor$/ do
  Observer.all.size.should == 1
end

Then /^I should have monitor for (.+)$/ do |monitor_name|
  return true if Observer.find_by(name: monitor_name)
end

Then /^I should have zero countries$/ do
  Observer.all.reload.size.should.zero?
end

Given /^monitor$/ do
  FactoryGirl.create(:observer, name: 'Monitor')
end
