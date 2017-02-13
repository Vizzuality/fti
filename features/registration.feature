Feature: Registration
In order to create account
As an user
I want to register

  Scenario: User minimal registration
    Given I am on the register page
    When I fill in "Email" with "user1@sample.com"
    And I fill in "* Password" with "qwertyui"
    And I fill in "* Confirm password" with "qwertyui"
    And I fill in "Name" with "Pepe"
    And I fill in "Username" with "pepe"
    And I press "Register"
    Then I should be on the dashboard page
    And I should see "Welcome! You have signed up successfully."
    And I should see "Hello Pepe"
    And I should have an user

  Scenario: User registration
    Given country
    And I am on the register page
    When I select "ngo" from "user_permissions_request"
    And I select "Australia" from "user_country_id"
    And I fill in "Email" with "user1@sample.com"
    And I fill in "* Password" with "qwertyui"
    And I fill in "* Confirm password" with "qwertyui"
    And I fill in "Name" with "Pepe"
    And I fill in "Username" with "pepe"
    And I fill in "Institution" with "Columpio"
    And I press "Register"
    Then I should be on the dashboard page
    And I should see "Welcome! You have signed up successfully."
    And I should see "Hello Pepe"
    And I should have an user
