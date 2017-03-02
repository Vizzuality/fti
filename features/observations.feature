Feature: Observation
In order to manage observations
As a adminuser
I want to manage a observation

  Scenario: User can not view observations page without login
    Given observation
    When I go to the observations page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can view observations
    Given observation
    And observation governance
    And I am authenticated user
    When I go to the observations page
    Then I should see "Illegality one"

  Scenario: A not admin user can view observation
    Given observation
    And observation governance
    And I am authenticated user
    When I go to the observation page for "Operator observation"
    Then I should be on the observation page for "Operator observation"
    And the disabled field "observation_evidence" should contain "Operator observation"

  Scenario: Adminuser can delete observation
    Given I am authenticated adminuser
    And observation
    When I go to the observations page
    And I follow "Delete"
    Then I should have zero observations
