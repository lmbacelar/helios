Feature: IEC 60751 Measurement Conversions

    As a   temperature metrologist
    In     order to use IEC 60751 compliant PRT's
    I want to get temperature from resistance and vice-versa

  Background: IEC 60751 PRT's on database
    Given the following "IEC 60751 PRT" exist:
      | name |
      | PRT1 |

  Scenario: Get temperature from resistance
    Given I am on the new "IEC 60751 Measurement" page for "IEC 60751 PRT" with name "PRT1"
    When  I fill in "Resistance" with "100"
    And   I press "Create"
    Then  I should be on the page of the last "IEC 60751 Measurement" for "IEC 60751 PRT" with name "PRT1"
    And   I should see "100.0000 Ohm"
    And   I should see "0.000 ºC"

  Scenario: Get resistance from temperature
    Given I am on the new "IEC 60751 Measurement" page for "IEC 60751 PRT" with name "PRT1"
    When  I fill in "Temperature" with "0"
    And   I press "Create"
    Then  I should be on the page of the last "IEC 60751 Measurement" for "IEC 60751 PRT" with name "PRT1"
    And   I should see "100.0000 Ohm"
    And   I should see "0.000 ºC"
