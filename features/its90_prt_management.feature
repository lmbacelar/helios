Feature: ITS90 PRT Management
  As a      temperature metrologist
  In order  manage temperature standards 
  I want to list, create, read, update and destroy ITS-90 compliant PRT's

  Scenario: List no PRTs when there are no PRTs
    Given I have no "ITS90 PRT"
    When  I visit the "ITS90 PRT" page
    Then  I should see "No Platinum Resistance Thermometers found" 
    And   I should see one "New PRT" link
    
  Scenario: List all PRTs when there are PRTs
    Given the "ITS90 PRT" with name "PRT1" exists
    And   the "ITS90 PRT" with name "PRT2" exists
    When  I visit the "ITS90 PRT" page
    Then  I should see "Name"
    And   I should see "PRT1"
    And   I should see "PRT2"

  Scenario: Displays New PRT links above and below existing PRTs
    Given the "ITS90 PRT" with name "PRT1" exists
    When  I visit the "ITS90 PRT" page
    Then  I should see 2 "New PRT" links
    And   I should see "New PRT" before "Name"
    And   I should see "PRT1" before "New PRT"

  # Scenario: Access the new PRT form
  #   When  I visit the "ITS90 PRT" page
  #   And   I follow "New PRT"
  #   Then  I should be on the new "ITS90 PRT" page
  #   And   I should see "Name" before "Description"
  #   And   I should see "R0" before "A"
  #   And   I should see "A" before "B"
  #   And   I should see "B" before "C"

  # Scenario: Create new PRT with valid data
  #   Given I am on the new "ITS90 PRT" page
  #   When  I fill in "Name" with "PRTX"
  #   When  I fill in "Description" with "Some description"
  #   And   I press "Create"
  #   Then  I should be on the page of the last "ITS90 PRT"
  #   And   I should see "PRTX" before "Some description"
  #   And   I should see "PRT was successfully created"

  # Scenario: Create new PRT with invalid data
  #   Given I am on the new "ITS90 PRT" page
  #   And   I press "Create"
  #   Then  I should see "Please review the problems below"
  #   And   I should see /Name\s*can't be blank/
  #   And   I should not see "PRT was successfully created"

  # Scenario: Show existing PRT
  #   Given the following "ITS90 PRT" exist:
  #     | name | description | r0    | a          | b           | c           |
  #     | PRT1 | Lo Temp     | 100.0 | 3.9083e-03 | -5.7750e-07 | -4.1830e-12 |
  #   When  I visit the "ITS90 PRT" page
  #   And   I follow "Details"
  #   Then  I should be on the page of "ITS90 PRT" with name "PRT1"
  #   And   I should see "Name" before "PRT1"
  #   And   I should see "R0" before "100.0000 Ohm"
  #   And   I should see "A" before "+3.90830E-03"
  #   And   I should see "B" before "-5.77500E-07"
  #   And   I should see "C" before "-4.18300E-12"

  # Scenario: Show link back to ITS90 PRTs page
  #   Given the following "ITS90 PRT" exist:
  #     | name | description | r0    | a          | b           | c           |
  #     | PRT1 | Lo Temp     | 100.0 | 3.9083e-03 | -5.7750e-07 | -4.1830e-12 |
  #   When  I visit the page of "ITS90 PRT" with name "PRT1"
  #   And   I follow "Back to PRT list"
  #   Then  I should be on the "ITS90 PRT" page

  # Scenario: Delete PRT
  #   Given the following "ITS90 PRT" exist:
  #     | name | description | r0    | a          | b           | c           |
  #     | PRT1 | Lo Temp     | 100.0 | 3.9083e-03 | -5.7750e-07 | -4.1830e-12 |
  #   When  I visit the "ITS90 PRT" page
  #   And   I follow "Destroy"
  #   Then  I should be on the "ITS90 PRT" page
  #   And   I should see "PRT was successfully destroyed"
  #   And   I should not see "PRT1"
