Feature: IEC 60584 Function Management
  As a      temperature metrologist
  In order  manage temperature standards 
  I want to list, create, read, update and destroy IEC 60584 Functions

  Scenario: List no IEC 60584 Functions when there are no IEC 60584 Functions
    Given I have no "IEC 60584 Function"
    When  I visit the "IEC 60584 Function" page
    Then  I should see "No IEC 60584 Functions found" 
    And   I should see one "New Function" link
    
  Scenario: List all IEC 60584 Functions when there are IEC 60584 Functions
    Given the following "IEC 60584 Function" exist:
      | name | type |
      | FNC1 | K    | 
      | FNC2 | T    | 
    When  I visit the "IEC 60584 Function" page
    Then  I should see "Name" before "FNC1"
    And   I should see "FNC2"

  Scenario: Displays New Function links above and below existing Functions
    Given the following "IEC 60584 Function" exist:
      | name | type |
      | FNC1 | K    | 
    When  I visit the "IEC 60584 Function" page
    Then  I should see 2 "New Function" links
    And   I should see "New Function" before "Name"
    And   I should see "FNC1" before "New Function"

  Scenario: Access the new IEC 60584 Function form
    When  I visit the "IEC 60584 Function" page
    And   I follow "New Function"
    Then  I should be on the new "IEC 60584 Function" page
    And   I should see "Name"
    And   I should see "Type"
    And   I should see "a3" before "a2"
    And   I should see "a2" before "a1"
    And   I should see "a1" before "a0"

  Scenario: Create new IEC 60584 Function with valid data
    Given I am on the new "IEC 60584 Function" page
    When  I fill in "Name" with "FNCX"
    And   I fill in "Type" with "K"
    And   I press "Create"
    Then  I should be on the page of the last "IEC 60584 Function"
    And   I should see "FNCX"
    And   I should see "K"
    And   I should see "Function was successfully created"

  Scenario: Create new IEC 60584 Function with invalid data
    Given I am on the new "IEC 60584 Function" page
    And   I press "Create"
    Then  I should see "Please review the problems below"
    And   I should see /Name\s*can't be blank/
    And   I should not see "Function was successfully created"

  Scenario: Show existing IEC 60584 Function
    Given the following "IEC 60584 Function" exist:
      | name | type | a3      | a2      | a1      | a0      |
      | FNC1 | R    | 1.1e-09 | 2.2e-04 | 3.3e-02 | 4.4e+00 |
    When  I visit the "IEC 60584 Function" page
    And   I follow "Details"
    Then  I should be on the page of "IEC 60584 Function" with name "FNC1"
    And   I should see "Name" before "FNC1"
    And   I should see "Type" before "R"
    And   I should see "a3" before "+1.10000E-09"
    And   I should see "a2" before "+2.20000E-04"
    And   I should see "a1" before "+3.30000E-02"
    And   I should see "a0" before "+4.40000E+00"

  Scenario: Show link back to IEC 60584 Functions page
    Given the following "IEC 60584 Function" exist:
      | name | type |
      | FNC1 | K    | 
    When  I visit the page of "IEC 60584 Function" with name "FNC1"
    And   I follow "Back to IEC 60584 Function list"
    Then  I should be on the "IEC 60584 Function" page

  Scenario: Delete IEC 60584 Function
    Given the following "IEC 60584 Function" exist:
      | name | type |
      | FNC1 | K    | 
    When  I visit the "IEC 60584 Function" page
    And   I follow "Destroy"
    Then  I should be on the "IEC 60584 Function" page
    And   I should see "Function was successfully destroyed"
    And   I should not see "FNC1"
