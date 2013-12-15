Feature: ITS90 Function Management
  As a      temperature metrologist
  In order  manage temperature standards 
  I want to list, create, read, update and destroy ITS-90 compliant Functions

  Scenario: List no ITS-90 Functions when there are no ITS-90 Functions
    Given I have no "ITS90 Function"
    When  I visit the "ITS90 Function" page
    Then  I should see "No ITS-90 Functions found" 
    And   I should see one "New Function" link
    
  Scenario: List all ITS-90 Functions when there are ITS-90 Functions
    Given the following "ITS90 Function" exist:
      | name | sub_range |
      | FNC1 | 7         | 
      | FNC2 | 7         | 
    When  I visit the "ITS90 Function" page
    Then  I should see "Name"
    And   I should see "FNC1"
    And   I should see "FNC2"

  Scenario: Displays New Function links above and below existing Functions
    Given the following "ITS90 Function" exist:
      | name | sub_range |
      | FNC1 | 7         | 
    When  I visit the "ITS90 Function" page
    Then  I should see 2 "New Function" links
    And   I should see "New Function" before "Name"
    And   I should see "FNC1" before "New Function"

  Scenario: Access the new ITS-90 Function form
    When  I visit the "ITS90 Function" page
    And   I follow "New Function"
    Then  I should be on the new "ITS90 Function" page
    And   I should see "Sub range"
    And   I should see "Rtpw"
    And   I should see /A.*B.*C.*D/
    And   I should see "W660"
    And   I should see /C1.*C2.*C3.*C4.*C5/

  Scenario: Create new ITS-90 Function with valid data
    Given I am on the new "ITS90 Function" page
    When  I fill in "Name" with "FNCX"
    And   I fill in "Sub range" with "7"
    And   I press "Create"
    Then  I should be on the page of the last "ITS90 Function"
    And   I should see "FNCX"
    And   I should see "Function was successfully created"

  Scenario: Create new ITS-90 Function with invalid data
    Given I am on the new "ITS90 Function" page
    And   I press "Create"
    Then  I should see "Please review the problems below"
    And   I should see /Name\s*can't be blank/
    And   I should see /Sub range\s*can't be blank/
    And   I should not see "Function was successfully created"

  Scenario: Show existing ITS-90 Function
    Given the following "ITS90 Function" exist:
      | name | sub_range |
      | FNC1 | 7         | 
    When  I visit the "ITS90 Function" page
    And   I follow "Details"
    Then  I should be on the page of "ITS90 Function" with name "FNC1"
    And   I should see "Name" before "FNC1"
    And   I should see "Sub-range"
    And   I should see /Rtpw.*25/
    And   I should see /A.*0.*B.*0.*C.*0.*D.*0/
    And   I should see /W660.*0/
    And   I should see /C1.*0.*C2.*0.*C3.*0.*C4.*0.*C5.*0/

  Scenario: Show link back to ITS90 Functions page
    Given the following "ITS90 Function" exist:
      | name | sub_range |
      | FNC1 | 7         | 
    When  I visit the page of "ITS90 Function" with name "FNC1"
    And   I follow "Back to ITS-90 Function list"
    Then  I should be on the "ITS90 Function" page

  Scenario: Delete ITS-90 Function
    Given the following "ITS90 Function" exist:
      | name | sub_range |
      | FNC1 | 7         | 
    When  I visit the "ITS90 Function" page
    And   I follow "Destroy"
    Then  I should be on the "ITS90 Function" page
    And   I should see "Function was successfully destroyed"
    And   I should not see "FNC1"
