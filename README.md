CensusBlockAggregator
=====================

A little hacked-together utility to get Census data using the public API

Requirements: CSV file with state and county FIPS codes plus Census tract identifiers, each in their own columns

Customizations: See the .pl script file for info on how to customize the query for your own specific needs. You also might have to break up the Census tracts CSV source file into multiple files because the API service can't always handle lots and lots of requests.

Get a Census API key: http://api.census.gov/data/key_signup.html

Good luck.

