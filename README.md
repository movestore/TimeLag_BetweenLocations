# Time Lag Between Locations

MoveApps

Github repository: https://github.com/movestore/TimeLag_BetweenLocations

## Documentation
This App calculates the time lag between each pair of consecutive locations of a track. The time lag is a segment characteristic and is assigned to the first location of each segment. Therefore the time lag of the last location of each track is set to NA.

A column named `timelag` is appended to the event data that is returned for further use in the next Apps. This column also contains the unit in which the time lag was calculated.

The median time lag per individual is added to the track data table as `median_timelag`. It represents the typical interval between consecutive recorded locations and provides a robust summary of the realised sampling frequency because it is less affected by occasional long gaps than the mean. Knowing the median time lag helps researchers assess the typical sampling frequency of each tag and choose realistic recording or resampling intervals for future analyses and deployments.

Histograms of the time lag distribution of all individuals together and of each individual are created automatically and can be downloaded as a PDF. Each histogram shows the median time lag as a dashed line, and its value in the subtitle.

### Application scope
#### Generality of App usability
This App was developed for any taxonomic group.

#### Required data properties
The App should work for any kind of location data. A time lag can only be calculated for tracks with at least two locations.

### Input type
`move2::move2_loc`

### Output type
`move2::move2_loc`

### Artefacts
`timelag_histogram.pdf`: PDF with histograms of the time lags. If the data contain more than one individual, the first page shows all individuals together, followed by one page per individual. If the data contain one individual, the PDF contains only the page of that individual. Each histogram shows the median time lag as a dashed line, with its value in the subtitle.

### Settings
`Units` (units): Unit in which the time lag between consecutive locations and the median time lag per individual are calculated. Available units are: `Seconds` (s), `Minutes` (min), `Hours` (h), `Days` (d), `Weeks` (weeks), `Month` (month) and `Years` (years). Default: `Minutes`.

### Changes in output data
The App adds to the event data the column `timelag`. It contains the time lag from each location to the next location of the same track, in the selected unit, with the unit information stored in the column. The last location of each track has the value NA.

The App adds to the track data table the column `median_timelag`. It contains the median of the time lags of each individual, in the selected unit.

All other data remain unchanged.

### Errors and null handling
**Input data:** The full input data set, with the added columns, is returned for further use in the next App. The input data cannot be empty.

**Tracks with only one location:** No time lag can be calculated. The `timelag` and `median_timelag` values of this track are NA, and its page in the PDF contains no bars and shows "Median: NA".

**Long gaps in the data:** Rare long time lags (e.g. days without recorded locations) stretch the x-axis of the histograms, so the bars of the shorter, more frequent time lags can appear compressed at the left. These long time lags are real gaps in the tracking data and are not removed by the App. They do not affect the median.

### Technical details
- The time lags are calculated with `mt_time_lags()` from the `move2` package. Units are handled with the `units` package, so the unit is stored together with the values.
- The units `Month` and `Years` are average lengths (a month is about 30.4 days, a year about 365.25 days).
- The median is calculated per individual, ignoring the NA of the last location of each track.
- The histograms are created with `ggplot2` using 100 bins over the range of the time lags.