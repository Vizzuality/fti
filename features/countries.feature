Feature: Countries
In order to manage countries
As a adminuser
I want to manage a categories

  Scenario: User can not view countries page and country page without login
    Given country
    When I go to the countries page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view countries
    Given country
    And I am authenticated user
    When I go to the countries page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view country
    Given I am authenticated adminuser
    And country
    When I go to the country page for "Australia"
    Then I should be on the country page for "Australia"
    And the disabled field "country_name" should contain "Australia"

  Scenario: Adminuser can edit country
    Given I am authenticated adminuser
    And country
    When I go to the edit country page for "Australia"
    And I fill in "country_name" with "Australia edited"
    And I press "Update"
    Then I should be on the countries page
    And I should see "Australia edited"

  Scenario: User can create country
    Given I am authenticated adminuser
    When I go to the new country page
    And I fill in "country_name" with "Country new name"
    And I fill in "country_iso" with "CNN"
    And I press "Create"
    Then I should have one country

  Scenario: Adminuser can not edit country without name
    Given I am authenticated adminuser
    And country
    When I go to the edit country page for "Australia"
    And I fill in "country_name" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate country
    Given I am authenticated adminuser
    When I go to the new country page
    And I fill in "country_name" with "Country new EN"
    And I fill in "country_iso" with "CNN"
    And I press "Create"
    Then I should have one country
    When I go to the edit country page for "Country new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "country_name" with "Country new FR"
    And I press "Update"
    Then I should be on the countries page
    And I should see "Country new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Country new EN"
