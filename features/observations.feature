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

  @javascript
  Scenario: Adminuser can edit observation
    Given I am authenticated adminuser
    And observation matched annex_operator
    Then I should have one country
    When I go to the edit observation page for "Operator observation"
    And I select from the following hidden field ".js-annex-severity" with "Illegality two"
    And I select from the following hidden field ".js-severity" with "2 - Two"
    And I press "Update"
    Then I should be on the observations page
    And I should see "Illegality two"

  Scenario: Adminuser can delete observation
    Given I am authenticated adminuser
    And observation
    When I go to the observations page
    And I follow "Delete"
    Then I should have zero observations

  # @javascript
  # Scenario: Adminuser can create an observation
  #   Given I am authenticated adminuser
  #   And country matched annex_operator
  #   And monitor
  #   When I go to the create observation page
  #   Then I should be on the observation first step
  #   When I select from the following hidden field "#observation_country_id" with "Test Country"
  #   And I select from the following hidden field "#observation_observation_type" with "Illegality"
  #   And I press "Continue"
  #   Then I should be on the observation second step
  #   When I select from the following hidden field ".js-annex-severity" with "Illegality two"
  #   And I select from the following hidden field ".js-severity" with "2 - Lorem ipsum.."
  #   And I fill in "observation_publication_date" with "01-01-2016"
  #   And I fill in "observation_pv" with "PV"
  #   And I fill in "observation_concern_opinion" with "Opinion"
  #   And I fill in "observation_litigation_status" with "Status"
  #   And I select from the following hidden field "#observation_observer_id" with "Monitor"
  #   And I fill in "observation_details" with "Details"
  #   And I fill in "observation_evidence" with "Evidence"
  #   And I press "Continue"
  #   Then I should be on the observation third step
  #   When I fill the observation third step
  #   Then I should go to observations
  #   And I should have a new observation
