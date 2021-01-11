import strutils

proc word*(word: string): string =
  return word.strip()
  # if len(name) <= max and len(name) > 2 and estimate(name) <= syllables:
  #   if name.isAvailable:
  #     return (true, name)
  # return (false, name)