Feature: Using the Wut Package
  In order to maintain sanity
  As a potentially crazy person
  I want to generate ruby scripts
  Very special ruby scripts
  With ASCII arts
  And obfuscated code

  Scenario: Creating a Wut Script
    Given an arbitrary string
    When I invoke wut
    Then a ruby script should be generated
