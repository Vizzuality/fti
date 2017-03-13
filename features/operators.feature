Feature: Operators
In order to manage operators
As a adminuser
I want to manage a operator

  Scenario: User can not view operators page without login
    Given operator
    When I go to the operators page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view operators
    Given operator
    And I am authenticated user
    When I go to the operators page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view operator
    Given I am authenticated adminuser
    And operator
    When I go to the operator page for "Operator"
    Then I should be on the operator page for "Operator"
    And the disabled field "operator_name" should contain "Operator"

  Scenario: Adminuser can edit operator
    Given I am authenticated adminuser
    And operator
    When I go to the edit operator page for "Operator"
    And I fill in "operator_name" with "Operator edited"
    And I press "Update"
    Then I should be on the operators page
    And I should see "Operator edited"

  Scenario: User can create operator
    Given I am authenticated adminuser
    And country
    When I go to the new operator page
    And I fill in "operator_name" with "Operator new name"
    And I select "Australia" from "operator_country_id"
    And I select "Logging Company" from "operator_operator_type"
    And I attach the file "spec/support/files/image.png" to "operator_logo"
    And I press "Create"
    Then I should have operator for "Operator new name"

  Scenario: Adminuser can not edit operator without name
    Given I am authenticated adminuser
    And operator
    When I go to the edit operator page for "Operator"
    And I fill in "operator_name" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate operator
    Given I am authenticated adminuser
    When I go to the new operator page
    And I fill in "operator_name" with "Operator new EN"
    And I press "Create"
    Then I should have operator for "Operator new EN"
    When I go to the edit operator page for "Operator new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "operator_name" with "Operator new FR"
    And I press "Update"
    Then I should be on the operators page
    And I should see "Operator new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Operator new EN"

  Scenario: Adminuser can delete operator
    Given I am authenticated adminuser
    And operator
    When I go to the operators page
    And I follow "Delete"
    Then I should have zero operators
