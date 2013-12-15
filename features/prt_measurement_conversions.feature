Feature: PRT Measurement Conversions

    As a   temperature metrologist
    In     order to use PRT's
    I want to get temperature from resistance and vice-versa

  Background: IEC 60751 Function's on database
    Given the "IEC 60751 Function" with name "FNC1" exists
    And   the following "ITS90 Function" exist:
      | name | sub_range |
      | FNC2 | 7         | 

  Scenario: Get temperature from resistance for IEC 60751
    Given I am on the new "PRT Measurement" page for "IEC 60751 Function" with name "FNC1"
    When  I fill in "Resistance" with "100"
    And   I press "Create"
    Then  I should be on the page of the last "PRT Measurement" for "IEC 60751 Function" with name "FNC1"
    And   I should see "100.0000 Ohm"
    And   I should see "0.000 ºC"

  Scenario: Get resistance from temperature for IEC 60751
    Given I am on the new "PRT Measurement" page for "IEC 60751 Function" with name "FNC1"
    When  I fill in "Temperature" with "0"
    And   I press "Create"
    Then  I should be on the page of the last "PRT Measurement" for "IEC 60751 Function" with name "FNC1"
    And   I should see "100.0000 Ohm"
    And   I should see "0.000 ºC"

  Scenario: Get temperature from resistance for ITS-90
    Given I am on the new "PRT Measurement" page for "ITS90 Function" with name "FNC2"
    When  I fill in "Resistance" with "25"
    And   I press "Create"
    Then  I should be on the page of the last "PRT Measurement" for "ITS90 Function" with name "FNC2"
    And   I should see "0.010 ºC"
