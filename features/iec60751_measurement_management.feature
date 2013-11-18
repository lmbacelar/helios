Feature: IEC 60751 Measurement Management
  As a      temperature metrologist
  In order  keep record of temperatures measured with IEC 60751 compliant PRT's
  I want to manage IEC 60751 temperature measurements

  Background: Iec 60751 Measurements in the database
    Given the following "IEC 60751 Measurements" exist:
      | temperature | created_at          |
      | 0           | 2013-01-01 00:00:00 | 
      | 0.23        | 2013-01-01 00:00:10 | 
      | 0.528       | 2013-01-01 00:00:20 | 

  Scenario: List all measurements
    When I visit the "IEC 60751 Measurements" page
    Then I should see "Temperature" 
    And  I should see "Resistance" 
    And  I should see "Date" 
    And  I should see "Time" 
    And  "0.528" should appear before "0.230"
    And  I should see "100.0000" 
    And  I should see "2013-01-01"
    And  I should see "00:00:10"
    
  Scenario: Delete measurement
    When I visit the "IEC 60751 Measurements" page
    And  I follow the first "Destroy"
    Then I should be on the "IEC 60751 Measurements" page
    And  I should see "Measurement was successfully destroyed"
    And  I should not see "0.528"
    And  "0.230" should appear before "0.000"

  Scenario: Search measurements by date
