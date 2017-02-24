Feature: Users
In order to manage users
As an adminuser
I want to edit, view, activate, deactivate and change user permissions

  Scenario: User can view users page and user page
    Given I am authenticated adminuser
    And user
    When I go to the users page
    And I should see "Pepe"
    When I follow "Pepe"
    Then I should be on the user page for "pepe@exaple.com"
    And I should see "Pepe"

  Scenario: Adminuser can edit user
    Given user
    And I am authenticated adminuser
    When I go to the edit user page for "pepe@exaple.com"
    And I fill in "user_name" with "Don"
    And I fill in "user_institution" with "Radio 3"
    And I fill in "user_email" with "don-morenito@sample.com"
    And I press "Update"
    And the disabled field "Email" should contain "don-morenito@sample.com" within ".form-actions"
    And the disabled field "Institution" should contain "Radio 3" within ".form-actions"

  Scenario: Adminuser can deactivate and activate user
    Given user
    And I am authenticated adminuser
    When I go to the user page for "pepe@exaple.com"
    And I follow "Deactivate"
    Then I should be on the users page
    And I should see "deactivated"
    When I go to the users page with filter active
    Then I should not see "(deactivated)"
    When I go to the user page for "pepe@exaple.com"
    And I follow "Activate"
    Then I should be on the users page
    And I should not see "(deactivated)"

  Scenario: Adminuser can make user admin
    Given user
    And I am authenticated adminuser
    When I go to the edit user page for "pepe@exaple.com"
    And I follow "Permissions"
    And I follow "Edit permissions"
    When I select "admin" from "user_permission_user_role"
    And I press "Update"
    Then I should be on the user page for "pepe@exaple.com"
    Then I should have two adminusers

  Scenario: Adminuser can make user ngo
    Given user
    And I am authenticated adminuser
    When I go to the edit user page for "pepe@exaple.com"
    And I follow "Permissions"
    And I follow "Edit permissions"
    When I select "ngo" from "user_permission_user_role"
    And I press "Update"
    Then I should be on the user page for "pepe@exaple.com"
    Then I should have one ngo

  Scenario: Adminuser can make user operator
    Given user
    And I am authenticated adminuser
    When I go to the edit user page for "pepe@exaple.com"
    And I follow "Permissions"
    And I follow "Edit permissions"
    When I select "operator" from "user_permission_user_role"
    And I press "Update"
    Then I should be on the user page for "pepe@exaple.com"
    Then I should have one operator for user
