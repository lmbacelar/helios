Feature: IEC 60751 Measurement Management
  As a      temperature metrologist
  In order  keep record of temperatures measured with IEC 60751 compliant PRT's
  I want to create, list and destroy IEC 60751 temperature measurements

  Scenario: List all measurements when there are no measurements
    Given I have no "IEC 60751 Measurements"
    When  I visit the "IEC 60751 Measurements" page
    Then  I should see "No measurements found" 
    And   I should see one "New Measurement" link
    
  Scenario: List all measurements when there are measurements
    Given the following "IEC 60751 Measurements" exist:
      | temperature | created_at          |
      | 0.23        | 2013-01-01 00:00:10 | 
      | 0           | 2013-01-01 00:00:00 | 
      | 0.528       | 2013-01-01 00:00:20 | 
    When  I visit the "IEC 60751 Measurements" page
    Then  I should see "Date" before "Time"
    And   I should see "2013-01-01" before "00:00:10"
    And   I should see "Temperature" before "Resistance"
    And   I should see "0.000" before "100.0000" 
    And   I should see "0.528" before "0.230" 
    And   I should see "0.230" before "0.000" 

  Scenario: List latest measurements first
    Given the following "IEC 60751 Measurements" exist:
      | temperature | created_at          |
      | 0.23        | 2013-01-01 00:00:10 | 
      | 0.528       | 2013-01-01 00:00:20 | 
    When  I visit the "IEC 60751 Measurements" page
    Then  I should see "0.528" before "0.230"
    
  Scenario: Displays New measurement links above and below existing measurements
    Given the following "IEC 60751 Measurements" exist:
      | temperature | created_at          |
      | 0           | 2013-01-01 00:00:00 | 
    When  I visit the "IEC 60751 Measurements" page
    Then  I should see 2 "New Measurement" links
    And   I should see "New Measurement" before "Date"
    And   I should see "0.000" before "New Measurement"

  Scenario: Access the new measurement form
    When  I visit the "IEC 60751 Measurements" page
    And   I follow the first "New Measurement"
    Then  I should be on the new "IEC 60751 Measurement" page
    And   I should see "Temperature"
    And   I should see "Resistance"

  Scenario: Create new measurement with valid data
    Given I am on the new "IEC 60751 Measurement" page
    When  I fill in "Temperature" with "3.2"
    And   I press "Create"
    Then  I should be on the page of the last "IEC 60751 Measurement"
    And   I should see "3.200 ºC"
    And   I should see "Measurement was successfully created"

  Scenario: Create new measurement with invalid data
    Given I am on the new "IEC 60751 Measurement" page
    And   I press "Create"
    Then  I should see "Please review the problems below"
    And   I should see "Either temperature or resistance required"
    And   I should not see "Measurement was successfully created"

  Scenario: Delete measurement
    Given the following "IEC 60751 Measurements" exist:
      | temperature | created_at          |
      | 0.23        | 2013-01-01 00:00:10 | 
    When  I visit the "IEC 60751 Measurements" page
    And   I follow "Destroy"
    Then  I should be on the "IEC 60751 Measurements" page
    And   I should see "Measurement was successfully destroyed"
    And   I should not see "0.528"
