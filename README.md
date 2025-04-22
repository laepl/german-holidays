# German Holidays Typst Package

## Overview

This package provides functionality to retrieve a list of German holidays and check if a specific date is a holiday.

## Features

- [x] **Check Holiday**: Verify if a specific date is a German holiday.
- [x] **List German Holidays**: Get a comprehensive list of German holidays for a given year.
- [x] **Include differences for states**: Get a list of the holidays for a given state.

# Usage
```typst
# Check if April 15, 2025 is a holiday
#import "src/lib.typ": *

date = datetime(year: 2025, month: 4, day: 15)

For #date.display() #is-holiday(date, fed-state: "HH") is returned, because it's #which-holiday(date).

Get a list of holidays with #list-holidays(2025, lang: "en")
```
