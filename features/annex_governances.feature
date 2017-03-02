Feature: AnnexOperators
In order to manage annex_governances
As a adminuser
I want to manage a annex_governance

  Scenario: User can not view annex_governances page without login
    Given annex_governance
    When I go to the annex_governances page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view annex_governances
    Given annex_governance
    And I am authenticated user
    When I go to the annex_governances page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view annex_governance
    Given I am authenticated adminuser
    And annex_governance
    When I go to the annex_governance page for "Problem one"
    Then I should be on the annex_governance page for "Problem one"
    And the disabled field "annex_governance_governance_problem" should contain "Problem one"

  Scenario: Adminuser can edit annex_governance
    Given I am authenticated adminuser
    And annex_governance
    When I go to the edit annex_governance page for "Problem one"
    And I fill in "annex_governance_governance_problem" with "Problem edited"
    And I press "Update"
    Then I should be on the annex_governances page
    And I should see "Problem edited"

  Scenario: User can create annex_governance
    Given I am authenticated adminuser
    And country
    And law
    When I go to the new annex_governance page
    And I fill in "annex_governance_governance_pillar" with "Problem new governance pillar"
    And I fill in "annex_governance_governance_problem" with "Problem new governance problem"
    And I press "Create"
    Then I should have annex_governance for "Problem new governance problem"

  Scenario: Adminuser can not edit annex_governance without governance problem
    Given I am authenticated adminuser
    And annex_governance
    When I go to the edit annex_governance page for "Problem one"
    And I fill in "annex_governance_governance_problem" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate annex_governance
    Given I am authenticated adminuser
    When I go to the new annex_governance page
    And I fill in "annex_governance_governance_pillar" with "Prillar new EN"
    And I fill in "annex_governance_governance_problem" with "Problem new EN"
    And I press "Create"
    Then I should have annex_governance for "Problem new EN"
    When I go to the edit annex_governance page for "Problem new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "annex_governance_governance_problem" with "Problem new FR"
    And I press "Update"
    Then I should be on the annex_governances page
    And I should see "Problem new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Problem new EN"

  Scenario: Adminuser can delete annex_governance
    Given I am authenticated adminuser
    And annex_governance
    When I go to the annex_governances page
    And I follow "Delete"
    Then I should have zero annex_governances
