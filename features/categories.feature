Feature: Categories
In order to manage categories
As a adminuser
I want to manage a category

  Scenario: User can not view categories page and category page without login
    Given category
    When I go to the categories page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: Adminser can view category
    Given I am authenticated adminuser
    And category
    When I go to the category page for "Category one"
    Then I should be on the category page for "Category one"
    And the disabled field "category_name" should contain "Category one"

  Scenario: Adminuser can edit category
    Given I am authenticated adminuser
    And category
    And category_two
    When I go to the edit category page for "Category one"
    And I fill in "category_name" with "Category new name"
    And I press "Update"
    Then I should be on the categories page
    And I should see "Category new name"

  Scenario: User can create category for owned actor
    Given I am authenticated adminuser
    When I go to the new category page
    And I fill in "category_name" with "Category new name"
    And I press "Create"
    Then I should have one category

  Scenario: Adminuser can not edit category without name
    Given I am authenticated adminuser
    And category
    When I go to the edit category page for "Category one"
    And I fill in "category_name" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"
