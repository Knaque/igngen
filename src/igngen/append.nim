import strutils

proc prefix*(word: string, prefix: string): string =
  return prefix.strip() & word.strip()
  # if len(name) <= max and len(name) > 2:
  #   if name.isAvailable:
  #     return (true, name)
  # return (false, name)

proc suffix*(word: string, suffix: string): string =
  return word.strip() & suffix.strip()
  # if len(name) <= max and len(name) > 2:
  #   if name.isAvailable:
  #     return (true, name)
  # return (false, name)