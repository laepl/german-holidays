#import "config.typ": default-state, default-lang
#import "translations.typ": translate-day

#let check-state(fed-state) = {
  if fed-state == none or fed-state == "ALL" { return }
  let fed-states = (
    BB: "Brandenburg",
    BE: "Berlin",
    BW: "Baden-Württemberg",
    BY: "Bayern",
    HB: "Bremen",
    HE: "Hessen",
    HH: "Hamburg",
    MV: "Mecklenburg-Vorpommern",
    NI: "Niedersachsen",
    NW: "Nordrhein-Westfalen",
    RP: "Rheinland-Pfalz",
    SL: "Saarland",
    SN: "Sachsen",
    ST: "Sachsen-Anhalt",
    SH: "Schleswig-Holstein",
    TH: "Thüringen",
    AB: "Augsburg"
  )
  if fed-state not in fed-states.keys() {
    let msg = fed-state + " is no valid state abbreviation. Use one of these instead: "
    for element in fed-states {
      msg += element.at(0) + " = " + element.at(1) + ", "
    }
    panic(msg)
  }
}

#let list-holidays(year, fed-state: default-state, lang: default-lang) = {
  if type(fed-state) == str {
    fed-state = upper(fed-state)
  }
  check-state(fed-state)

  let a = calc.rem(year, 19)
  let b = calc.floor(year / 100)
  let c = calc.rem(year, 100)
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

  let ostersonntag = datetime(year: year, month: n, day: o + 1)

  let holidays = (
    translate-day(1, lang: lang): datetime(year: year, month: 1, day: 1), // Neujahr
    translate-day(4, lang: lang): ostersonntag - duration(days: 2), // Karfreitag
    translate-day(5, lang: lang): ostersonntag, // Ostersonntag
    translate-day(6, lang: lang): ostersonntag + duration(days: 1), // Ostermontag
    translate-day(7, lang: lang): datetime(year: year, month: 5, day: 1), // Tag der Arbeit
    translate-day(8, lang: lang): ostersonntag + duration(days: 39), // Christi Himmelfahrt
    translate-day(9, lang: lang): ostersonntag + duration(days: 50), // Pfingstmontag
    translate-day(14, lang: lang): datetime(year: year, month: 10, day: 3), // Tag der deutschen Einheit
    translate-day(18, lang: lang): datetime(year: year, month: 12, day: 25), // 1. Weihnachtsfeiertag
    translate-day(19, lang: lang): datetime(year: year, month: 12, day: 26), // 2. Weihnachtsfeiertag
  )

  // Heilige Drei Könige
  if fed-state in ("BW", "BY", "AB", "ST", "ALL") {
    holidays.insert(translate-day(2, lang: lang), datetime(year: year, month: 1, day: 6))
  }
  // Internationaler Frauentag
  if fed-state in ("BE", "MV", "ALL") {
    holidays.insert(translate-day(3, lang: lang), datetime(year: year, month: 3, day: 8))
  }
  // Fronleichnam
  if fed-state in ("BW", "BY", "AB", "HE", "MW", "RP", "SL", "SN", "TH", "ALL") {
    holidays.insert(translate-day(10, lang: lang), ostersonntag + duration(days: 60))
  }
  // Augsburger Friedensfest
  if fed-state in ("AB", "ALL") {
    holidays.insert(translate-day(11, lang: lang), datetime(year: year, month: 8, day: 8))
  }
  // Mariä Himmelfahrt
  if fed-state in ("SL", "BY", "AB", "ALL") {
    holidays.insert(translate-day(12, lang: lang), datetime(year: year, month: 8, day: 15))
  }
  // Weltkindertag
  if fed-state in ("TH", "ALL") {
    holidays.insert(translate-day(13, lang: lang), datetime(year: year, month: 9, day: 20))
  }
  // Reformationstag
  if fed-state in ("BB", "HB", "HH", "MV", "NI", "SN", "ST", "SH", "TH", "ALL") {
    holidays.insert(translate-day(15, lang: lang), datetime(year: year, month: 10, day: 31))
  }
  // Allerheiligen
  if fed-state in ("BW", "BY", "AB", "MW", "RP", "SL", "ALL") {
    holidays.insert(translate-day(16, lang: lang), datetime(year: year, month: 11, day: 1))
  }
  // Buß- und Bettag
  if fed-state in ("SN", "ALL") {
    let bußBettag = datetime(year: year, month: 11, day: 23)
    while bußBettag.weekday() != 3 {
      bußBettag -= duration(days: 1)
    }
    holidays.insert(translate-day(17, lang: lang), bußBettag)
  }
  // Sort dictionary as array and convert back to dictionary
  let sorted_arr = holidays.pairs().sorted(key: k => k.at(1))
  let sorted_dict = (:)
  for elem in sorted_arr {
    sorted_dict.insert(elem.at(0), elem.at(1))
  }
  return sorted_dict
}

#let is-holiday(date, fed-state: default-state) = {
  return date in list-holidays(date.year(), fed-state: fed-state).values()
}

#let which-holiday(date, fed-state: default-state, lang: default-lang) = {
  let holidays = list-holidays(date.year(), fed-state: fed-state, lang: lang)
  if date not in holidays.values() { return "no holiday" } else {
    for (holiday, day) in holidays.pairs() {
      if date == day { return holiday }
    }
  }
}