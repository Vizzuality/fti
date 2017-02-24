Feature: Governments
In order to manage governments
As a adminuser
I want to manage a government

  Scenario: User can not view governments page without login
    Given government
    When I go to the governments page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view governments
    Given government
    And I am authenticated user
    When I go to the governments page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view government
    Given I am authenticated adminuser
    And government
    When I go to the government page for "Government"
    Then I should be on the government page for "Government"
    And the disabled field "government_government_entity" should contain "Government"

  Scenario: Adminuser can edit government
    Given I am authenticated adminuser
    And government
    When I go to the edit government page for "Government"
    And I fill in "government_government_entity" with "Government edited"
    And I press "Update"
    Then I should be on the governments page
    And I should see "Government edited"

  Scenario: User can create government
    Given I am authenticated adminuser
    And country
    When I go to the new government page
    And I fill in "government_government_entity" with "Government new name"
    And I select "Australia" from "government_country_id"
    And I press "Create"
    Then I should have government for "Government new name"

  Scenario: Adminuser can not edit government without name
    Given I am authenticated adminuser
    And government
    When I go to the edit government page for "Government"
    And I fill in "government_government_entity" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate government
    Given I am authenticated adminuser
    When I go to the new government page
    And I fill in "government_government_entity" with "Government new EN"
    And I press "Create"
    Then I should have government for "Government new EN"
    When I go to the edit government page for "Government new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "government_government_entity" with "Government new FR"
    And I press "Update"
    Then I should be on the governments page
    And I should see "Government new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Government new EN"
