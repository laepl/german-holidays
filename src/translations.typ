#import "config.typ": default-lang

#let translate-day(day, lang: default-lang) = {
  let day-names = toml("translations.toml")
  return day-names.at(lower(lang)).at(str(day))
}