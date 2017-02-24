Feature: Species
In order to manage species
As a adminuser
I want to manage a species

  Scenario: User can not view species page without login
    Given species
    When I go to the species page
    And I should see "You need to sign in or sign up before continuing."
    Then I should be on the login page

  Scenario: A not admin user can't view species
    Given species
    And I am authenticated user
    When I go to the species page
    Then I should see "You are not authorized to access this page"

  Scenario: Adminuser can view species
    Given I am authenticated adminuser
    And species
    When I go to the species page for "Red resurrexit"
    Then I should be on the species page for "Red resurrexit"

  Scenario: Adminuser can edit species
    Given I am authenticated adminuser
    And species
    When I go to the edit species page for "Red resurrexit"
    And I fill in "species_name" with "Red resurrexit edited"
    And I press "Update"
    Then I should be on the species page
    And I should see "Red resurrexit edited"

  Scenario: User can create species
    Given I am authenticated adminuser
    And country
    When I go to the new species page
    And I fill in "species_name" with "Species new name"
    And I fill in "species_common_name" with "Rote rose new"
    And I select "Australia" from "species_country_ids"
    And I press "Create"
    Then I should have species for "Species new name"

  Scenario: Adminuser can not edit species without name
    Given I am authenticated adminuser
    And species
    When I go to the edit species page for "Red resurrexit"
    And I fill in "species_name" with ""
    And I press "Update"
    Then I should see "Please review the problems below:"
    And I should see "can't be blank"

  Scenario: translate species common name
    Given I am authenticated adminuser
    When I go to the new species page
    And I fill in "species_name" with "Species new EN"
    And I fill in "species_common_name" with "Rote rose new"
    And I press "Create"
    Then I should have species for "Species new EN"
    When I go to the edit species page for "Species new EN"
    Then I should have locale "en"
    When I follow "Français"
    Then I should have locale "fr"
    When I fill in "species_common_name" with "Rote rose new FR"
    And I press "Update"
    Then I should be on the species page
    And I should see "Rote rose new FR"
    When I follow "English"
    Then I should have locale "en"
    And I should see "Species new EN"
