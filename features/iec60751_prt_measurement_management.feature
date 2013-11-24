Feature: IEC 60751 PRT Measurement Management
  As a      temperature metrologist
  In order  keep record of temperatures measured with IEC 60751 compliant PRT's
  I want to create, list and destroy IEC 60751 PRT temperature measurements

  Background: IEC 60751 PRT's on database
    Given the "IEC 60751 PRT" with name "PRT1" exists

  Scenario: List all measurements when there are no measurements
    Given I have no "Measurements" for "IEC 60751 PRT" with name "PRT1"
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    Then  I should see "No measurements found" 
    And   I should see one "New Measurement" link
    
  Scenario: List all measurements when there are measurements
    Given the following "Measurements" exist for "IEC 60751 PRT" with name "PRT1":
      | temperature | created_at          |
      | 0.23        | 2013-01-01 00:00:10 | 
      | 0           | 2013-01-01 00:00:00 | 
      | 0.528       | 2013-01-01 00:00:20 | 
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    Then  I should see "Date" before "Time"
    And   I should see "2013-01-01" before "00:00:10"
    And   I should see "Temperature" before "Resistance"
    And   I should see "0.000" before "100.0000" 
    And   I should see "0.528"
    And   I should see "0.230"

  Scenario: List latest measurements first
    Given the following "Measurements" exist for "IEC 60751 PRT" with name "PRT1":
      | temperature | created_at          |
      | 0.23        | 2013-01-01 00:00:10 | 
      | 0.528       | 2013-01-01 00:00:20 | 
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    Then  I should see "0.528" before "0.230"
    
  Scenario: Displays New measurement links above and below existing measurements
    Given the following "Measurements" exist for "IEC 60751 PRT" with name "PRT1":
      | temperature | created_at          |
      | 0           | 2013-01-01 00:00:00 | 
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    Then  I should see 2 "New Measurement" links
    And   I should see "New Measurement" before "Date"
    And   I should see "0.000" before "New Measurement"

  Scenario: Access the new measurement form
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    And   I follow "New Measurement"
    Then  I should be on the new "PRT Measurement" page for "IEC 60751 PRT" with name "PRT1"
    And   I should see "Temperature"
    And   I should see "Resistance"

  Scenario: Create new measurement with valid data
    Given I am on the new "PRT Measurement" page for "IEC 60751 PRT" with name "PRT1"
    When  I fill in "Temperature" with "3.2"
    And   I press "Create"
    Then  I should be on the page of the last "PRT Measurement" for "IEC 60751 PRT" with name "PRT1"
    And   I should see "3.200 ºC"
    And   I should see "Measurement was successfully created"

  Scenario: Create new measurement with invalid data
    Given I am on the new "PRT Measurement" page for "IEC 60751 PRT" with name "PRT1"
    And   I press "Create"
    Then  I should see "Please review the problems below"
    And   I should see "Either temperature or resistance required"
    And   I should not see "Measurement was successfully created"

 Scenario: Delete measurement
    Given the following "Measurements" exist for "IEC 60751 PRT" with name "PRT1":
      | temperature | created_at          |
      | 0.23        | 2013-01-01 00:00:10 | 
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    And   I follow "Destroy"
    Then  I should be on the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    And   I should see "Measurement was successfully destroyed"
    And   I should not see "0.528"
