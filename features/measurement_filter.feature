Feature: Measurements Filtering

  As a metrologist
  In order to analyse measurements
  I want to filter the measurements I view

  Background: Measurements in the database
    Given the "IEC 60751 PRT" with name "PRT1" exists
    And   the following "Measurements" exist for "IEC 60751 PRT" with name "PRT1":
      | value | created_at          |
      | 0.23  | 2013-01-01 00:00:01 | 
      | 5.01  | 2013-01-01 12:00:01 | 
      | 12.80 | 2013-01-02 00:00:01 | 
      | 28.12 | 2013-01-02 12:00:01 | 
      | 55.28 | 2013-01-03 00:00:01 | 

  Scenario: Search measurements between times
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    And   I fill in "from" with "2013-01-02 00:00:00"
    And   I fill in "to" with "2013-01-02 23:59:59"
    And   I press "Refresh"
    Then  I should see "12.80"
    And   I should see "28.12"
    But   I should not see "0.23"
    And   I should not see "5.01"
    And   I should not see "55.28"

  Scenario: Search measurements after time
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    And   I fill in "from" with "2013-01-02 00:00:00"
    And   I press "Refresh"
    Then  I should see "12.80"
    And   I should see "28.12"
    And   I should see "55.28"
    But   I should not see "0.23"

  Scenario: Search measurements before time 
    When  I visit the "Measurements" page for "IEC 60751 PRT" with name "PRT1"
    And   I fill in "to" with "2013-01-02 00:00:00"
    And   I press "Refresh"
    Then  I should see "0.23"
    And   I should see "5.01"
    But   I should not see "12.80"
    And   I should not see "28.12"
    And   I should not see "55.28"
