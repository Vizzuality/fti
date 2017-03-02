# frozen_string_literal: true
Then /^I should have one category$/ do
  Category.count == 1
end

Then /^I should have category for (.+)$/ do |category_name|
  return true if Category.find_by(name: category_name)
end

Then /^I should have zero categories$/ do
  Category.count.zero?
end

Given /^category$/ do
  FactoryGirl.create(:category, name: 'Category one')
end

Given /^category_two$/ do
  FactoryGirl.create(:category, name: 'Category two')
end
