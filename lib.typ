#let is-holiday(date) = {
  let a = calc.rem(date.year(), 19)
  let b = calc.floor(date.year() / 100)
  let c = calc.rem(date.year(), 100)
  let d = calc.floor(b / 4)
  let e = calc.rem(b, 4)
  let f = calc.floor((b + 8) / 25)
  let g = calc.floor((b - f + 1) / 3)
  let h = calc.rem(19 * a + b - d - g + 15, 30)
  let i = calc.floor(c / 4)
  let k = calc.rem(c, 4)
  let l = calc.rem(32 + 2 * e + 2 * i - h - k, 7)
  let m = calc.floor((a + 11 * h + 22 * l) / 451)
  let n = calc.floor((h + l - 7 * m + 114) / 31)
  let o = calc.rem(h + l - 7 * m + 114, 31)

  let ostersonntag = datetime(year: date.year(), month: n, day: o + 1)

  let holidays = (
    datetime(year: date.year(), month: 1, day: 1), // Neujahr
    ostersonntag - duration(days: 2), // Karfreitag
    ostersonntag, // Ostersonntag
    ostersonntag + duration(days: 1), // Ostermontag
    datetime(year: date.year(), month: 5, day: 1), // 1. Mai
    ostersonntag + duration(days: 39), // Christi Himmelfahrt
    ostersonntag + duration(days: 50), // Pfingstmontag
    datetime(year: date.year(), month: 10, day: 3), // Tag der deutschen Einheit
    datetime(year: date.year(), month: 10, day: 31), // Reformationstag
    datetime(year: date.year(), month: 12, day: 25), // 1. Weihnachtsfeiertag
    datetime(year: date.year(), month: 12, day: 26), // 2. Weihnachtsfeiertag
  )
  return date in holidays
}