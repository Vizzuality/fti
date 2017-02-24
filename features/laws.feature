Feature: Laws
In order to manage laws
As a adminuser
I want to manage a law

  Scenario: User can not view laws page without login
    Given law
    When I go to the laws page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view laws
    Given law
    And I am authenticated user
    When I go to the laws page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view law
    Given I am authenticated adminuser
    And law
    When I go to the law page for "Law"
    Then I should be on the law page for "Law"
    And the disabled field "law_legal_reference" should contain "Law"

  Scenario: Adminuser can edit law
    Given I am authenticated adminuser
    And law
    When I go to the edit law page for "Law"
    And I fill in "law_legal_reference" with "Law edited"
    And I press "Update"
    Then I should be on the laws page
    And I should see "Law edited"

  Scenario: User can create law
    Given I am authenticated adminuser
    And country
    When I go to the new law page
    And I fill in "law_legal_reference" with "Law new name"
    And I select "Australia" from "law_country_id"
    And I press "Create"
    Then I should have law for "Law new name"

  Scenario: Adminuser can not edit law without name
    Given I am authenticated adminuser
    And law
    When I go to the edit law page for "Law"
    And I fill in "law_legal_reference" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate law
    Given I am authenticated adminuser
    When I go to the new law page
    And I fill in "law_legal_reference" with "Law new EN"
    And I press "Create"
    Then I should have law for "Law new EN"
    When I go to the edit law page for "Law new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "law_legal_reference" with "Law new FR"
    And I press "Update"
    Then I should be on the laws page
    And I should see "Law new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Law new EN"
