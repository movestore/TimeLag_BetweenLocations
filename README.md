# Time Lag Between Locations

MoveApps

Github repository: https://github.com/movestore/TimeLag_BetweenLocations

## Description
Calculation of the time lag between consecutive locations.

## Documentation
This App calculates the time lag between each consecutive locations. This measurement is a segment characteristic, and will be assigned to the first location of each segment. Therefore the time lag of the last location of the track will be set to NA.

A histogram of the time lag distribution of all individuals and per individual is automatically created and can be downloaded in the output as a pdf

### Input data
moveStack in Movebank format

### Output data
moveStack in Movebank format

### Artefacts
`timelag_histogram.pdf`: PDF with histograms of the time lags per individual

### Parameters
**units**: Choose units in which the time lag between locations should be calculated. Available units are: seconds, minutes, hours & weeks. Default is minutes.

### Null or error handling
**Data**: The full input dataset with the addition of time lag is returned for further use in a next App and cannot be empty.
