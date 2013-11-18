Feature: IEC 60751 Measurement Management
  As a      temperature metrologist
  In order  keep record of temperatures measured with IEC 60751 compliant PRT's
  I want to create, list and destroy IEC 60751 temperature measurements

  Background: Iec 60751 Measurements in the database
    Given the following "IEC 60751 Measurements" exist:
      | temperature | created_at          |
      | 0.23        | 2013-01-01 00:00:10 | 
      | 0           | 2013-01-01 00:00:00 | 
      | 0.528       | 2013-01-01 00:00:20 | 

  Scenario: List all measurements when there are no measurements
    Given I have no "IEC 60751 Measurements"
    When  I visit the "IEC 60751 Measurements" page
    Then  I should see "No measurements found" 
    And   I should see one "New Measurement" link
    
  Scenario: List all measurements when there are measurements
    When  I visit the "IEC 60751 Measurements" page
    Then  "Date" should appear before "Time"
    And   "2013-01-01" should appear before "00:00:10"
    And   "Temperature" should appear before "Resistance"
    And   "0.000" should appear before "100.0000" 

  Scenario: List latest measurements first
    When  I visit the "IEC 60751 Measurements" page
    Then  "0.528" should appear before "0.230"
    
  Scenario: Displays New measurement links above and below existing measurements
    When  I visit the "IEC 60751 Measurements" page
    Then  I should see 2 "New Measurement" links
    And   "New Measurement" should appear before "Date"
    And   "0.000" should appear before "New Measurement"

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
    Then  I should see "Either temperature or resistance required"
    Then  I should not see "Measurement was successfully created"

  Scenario: Delete measurement
    When  I visit the "IEC 60751 Measurements" page
    And   I follow the first "Destroy"
    Then  I should be on the "IEC 60751 Measurements" page
    And   I should see "Measurement was successfully destroyed"
    And   I should not see "0.528"
    And   "0.230" should appear before "0.000"
