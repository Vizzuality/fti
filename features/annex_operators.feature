Feature: AnnexOperators
In order to manage annex_operators
As a adminuser
I want to manage a annex_operator

  Scenario: User can not view annex_operators page without login
    Given annex_operator
    When I go to the annex_operators page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view annex_operators
    Given annex_operator
    And I am authenticated user
    When I go to the annex_operators page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view annex_operator
    Given I am authenticated adminuser
    And annex_operator
    When I go to the annex_operator page for "Illegality one"
    Then I should be on the annex_operator page for "Illegality one"
    And the disabled field "annex_operator_illegality" should contain "Illegality one"

  Scenario: Adminuser can edit annex_operator
    Given I am authenticated adminuser
    And annex_operator
    When I go to the edit annex_operator page for "Illegality one"
    And I fill in "annex_operator_illegality" with "Illegality edited"
    And I press "Update"
    Then I should be on the annex_operators page
    And I should see "Illegality edited"

  Scenario: User can create annex_operator
    Given I am authenticated adminuser
    And country
    And law
    When I go to the new annex_operator page
    And I fill in "annex_operator_illegality" with "Illegality new name"
    And I select "Australia" from "annex_operator_country_id"
    And I select "Law" from "annex_operator_law_id"
    And I press "Create"
    Then I should have annex_operator for "Illegality new name"

  Scenario: Adminuser can not edit annex_operator without name
    Given I am authenticated adminuser
    And annex_operator
    When I go to the edit annex_operator page for "Illegality one"
    And I fill in "annex_operator_illegality" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate annex_operator
    Given I am authenticated adminuser
    When I go to the new annex_operator page
    And I fill in "annex_operator_illegality" with "Illegality new EN"
    And I press "Create"
    Then I should have annex_operator for "Illegality new EN"
    When I go to the edit annex_operator page for "Illegality new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "annex_operator_illegality" with "Illegality new FR"
    And I press "Update"
    Then I should be on the annex_operators page
    And I should see "Illegality new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Illegality new EN"
