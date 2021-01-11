import strutils, regex

proc noVowels*(word: string): string =
  return word.strip().replace(re"[aeiou]", "")
  # if len(name) <= max and len(name) > 2:
  #   if name.isAvailable:
  #     return (true, name)
  # return (false, name)