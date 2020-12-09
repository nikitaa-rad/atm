# README

## Implementation of a simple ATM as a RESTful API.

Requirements:
1) An endpoint for adding money to the ATM by specifying an amount of each banknote.
Available banknotes: 1, 2, 5, 10, 25, 50.
Example of payload: {1: 10, 10: 10, 50: 10}

2) An endpoint for withdrawal that accepts an integer value and returns banknotes.
Example:
Entered value - 85, possible response - {50: 1, 10: 3, 1: 5}

3) Available banknotes amount should reduce with every withdrawal.

## Used Ruby 2.7, Rails 6.0.3, grape, Rspec (with factory_fot, airborne).
