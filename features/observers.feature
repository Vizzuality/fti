Feature: Monitors
In order to manage monitors
As a adminuser
I want to manage a monitor

  Scenario: User can not view monitors page without login
    Given monitor
    When I go to the monitors page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view monitors
    Given monitor
    And I am authenticated user
    When I go to the monitors page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view monitor
    Given I am authenticated adminuser
    And monitor
    When I go to the monitor page for "Monitor"
    Then I should be on the monitor page for "Monitor"
    And the disabled field "observer_name" should contain "Monitor"

  Scenario: Adminuser can edit monitor
    Given I am authenticated adminuser
    And monitor
    When I go to the edit monitor page for "Monitor"
    And I fill in "observer_name" with "Monitor edited"
    And I press "Update"
    Then I should be on the monitors page
    And I should see "Monitor edited"

  Scenario: User can create monitor
    Given I am authenticated adminuser
    And country
    When I go to the new monitor page
    And I fill in "observer_name" with "Monitor new name"
    And I select "Australia" from "observer_country_id"
    And I select "External" from "observer_observer_type"
    And I press "Create"
    Then I should have monitor for "Monitor new name"

  Scenario: Adminuser can not edit monitor without name
    Given I am authenticated adminuser
    And monitor
    When I go to the edit monitor page for "Monitor"
    And I fill in "observer_name" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate monitor
    Given I am authenticated adminuser
    When I go to the new monitor page
    And I fill in "observer_name" with "Monitor new EN"
    And I select "External" from "observer_observer_type"
    And I press "Create"
    Then I should have monitor for "Monitor new EN"
    When I go to the edit monitor page for "Monitor new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "observer_name" with "Monitor new FR"
    And I press "Update"
    Then I should be on the monitors page
    And I should see "Monitor new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Monitor new EN"
