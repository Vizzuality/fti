# frozen_string_literal: true
Then /^I should have an user$/ do
  User.filter_users.size.should >= 1
end

Then /^I should have an adminuser$/ do
  User.filter_admins.size.should >= 1
end

Then /^I should have one adminuser$/ do
  User.filter_admins.size.should == 1
end

Then /^I should have two adminusers$/ do
  User.filter_admins.size.should == 2
end

Then /^I should have one ngo$/ do
  User.filter_ngos.size.should == 1
end

Then /^I should have one operator$/ do
  User.filter_operators.size.should == 1
end

Then /^I should have zero operator$/ do
  User.filter_operators.size.should.zero?
end

Given /^I am authenticated user$/ do
  @user = FactoryGirl.create(:user)
  email = @user.email
  password = @user.password
  visit '/account/login'
  fill_in "Login", with: email
  fill_in "user_password", with: password
  click_button "login"
end

Given /^I am authenticated adminuser$/ do
  @user = FactoryGirl.create(:admin)
  email = @user.email
  password = @user.password
  visit '/account/login'
  fill_in "Login", with: email
  fill_in "user_password", with: password
  click_button "login"
end

Given /^I am registrated user$/ do
  @user = FactoryGirl.create(:user, email: 'test-user@sample.com', password: 'password')
end

Given /^user$/ do
  FactoryGirl.create(:user, name: 'Pepe', email: 'pepe@exaple.com')
end

Given /^guest user$/ do
  FactoryGirl.create(:user, email: 'pepe-moreno@sample.com')
end

Given /^adminuser$/ do
  FactoryGirl.create(:admin)
end
