#import "../lib.typ": *

= Get a list of holidays

You can get a list of all German holidays for 2025 with
```typ #list-holidays(2025, fed-state: "all")```
which returns a dictionary containing the names as keys and the dates as values: \
#list-holidays(2025, fed-state: "all")

You can get the dates for all country-wide holidays by not specifying the state or passing `none`
```typ
#list-holidays(2025, lang: "en")
```
returns an array of datetimes:

#list-holidays(2025, lang: "en")

= Test if a given date is a holiday
#let mydate = datetime(year: 2025, month: 4, day: 20)
#let mydate2 = datetime(year: 2025, month: 6, day: 19)


For #mydate.display() #is-holiday(mydate) is returned, because it's #which-holiday(mydate, lang: "en").

For #mydate2.display() #is-holiday(mydate2) is returned.

#let mydate3 = datetime(year: 2025, month: 10, day: 31)
The #mydate.display() is #which-holiday(mydate3, fed-state: "HH", lang: "en")