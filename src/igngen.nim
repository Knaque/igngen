import igngen/[novowels, word, append, availability]
import random, sequtils, dimscord, asyncdispatch, strutils, syllables, tables, options, times, regex
randomize()

const token {.strdefine.}: string = ""
if token == "":
  quit("Please supply your Discord bot token with -d:token=\"<token>\" when compiling.", QuitFailure)

var words = toSeq lines("words.txt")

var bot = newDiscordClient(token)

var unavails: Table[string, int8]

bot.events.on_ready = proc (s: Shard, r: Ready) {.async.} =
  echo "Ready to rumble!"

bot.events.message_create = proc (s: Shard, m: Message) {.async.} =
  var max = 16
  var embed: Embed

  if m.author.bot: return

  if m.content.startsWith(".w"):
    var botmsg = await bot.api.sendMessage(m.channel_id, "Working on it...")

    var syllables = 3

    let args = m.content.split(' ')
    for arg in args:
      if arg.match(re"^max=\d+$"):
        max = arg.split('=')[1].parseInt().clamp(3, 16)
      if arg.match(re"^syllables=\d+$"):
        syllables = arg.split('=')[1].parseInt().clamp(1, high(int))

    var prospect: tuple[name: string, avail: bool]
    let timer = now()
    while not prospect.avail:
      if inSeconds(now() - timer) > 5:
        embed.title = some("Took too long to generate name.")
        embed.color = some(15158332)
        discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed)); return
      let name = word(words.sample)
      var available = 
        not unavails.hasKey(name) and len(name) <= max and len(name) > 2 and
        estimate(name) <= syllables
      if available:
        let a = await name.isAvailable()
        available = a
      if not available:
        unavails[name] = 0
      prospect = (name, available)
    embed.title = some(prospect.name)
    embed.color = some(3066993)
    discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed))

  if m.content.startsWith(".v"):
    var botmsg = await bot.api.sendMessage(m.channel_id, "Working on it...")

    let args = m.content.split(' ')
    for arg in args:
      if arg.match(re"^max=\d+$"):
        max = arg.split('=')[1].parseInt().clamp(3, 16)

    var prospect: tuple[name: string, avail: bool]
    let timer = now()
    while not prospect.avail:
      if inSeconds(now() - timer) > 5:
        embed.title = some("Took too long to generate name.")
        embed.color = some(15158332)
        discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed)); return
      let name = noVowels(words.sample)
      var available = 
        not unavails.hasKey(name) and len(name) <= max and len(name) > 2
      if available:
        let a = await name.isAvailable()
        available = a
      if not available:
        unavails[name] = 0
      prospect = (name, available)
    embed.title = some(prospect.name)
    embed.color = some(3066993)
    discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed))

  if m.content.startsWith(".p"):
    var botmsg = await bot.api.sendMessage(m.channel_id, "Working on it...")

    var pre = "go"

    let args = m.content.split(' ')
    for arg in args:
      if arg.match(re"^max=\d+$"):
        max = arg.split('=')[1].parseInt().clamp(3, 16)
      if arg.match(re"^prefix=\w+$"):
        pre = arg.split('=')[1]

    var prospect: tuple[name: string, avail: bool]
    let timer = now()
    while not prospect.avail:
      if inSeconds(now() - timer) > 5:
        embed.title = some("Took too long to generate name.")
        embed.color = some(15158332)
        discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed)); return
      let name = prefix(words.sample, pre)
      var available = 
        not unavails.hasKey(name) and len(name) <= max and len(name) > 2
      if available:
        let a = await name.isAvailable()
        available = a
      if not available:
        unavails[name] = 0
      prospect = (name, available)
    embed.title = some(prospect.name)
    embed.color = some(3066993)
    discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed))

  if m.content.startsWith(".s"):
    var botmsg = await bot.api.sendMessage(m.channel_id, "Working on it...")

    var suf = "ok"

    let args = m.content.split(' ')
    for arg in args:
      if arg.match(re"^max=\d+$"):
        max = arg.split('=')[1].parseInt().clamp(3, 16)
      if arg.match(re"^suffix=\w+$"):
        suf = arg.split('=')[1]

    var prospect: tuple[name: string, avail: bool]
    let timer = now()
    while not prospect.avail:
      if inSeconds(now() - timer) > 5:
        embed.title = some("Took too long to generate name.")
        embed.color = some(15158332)
        discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed)); return
      let name = suffix(words.sample, suf)
      var available = 
        not unavails.hasKey(name) and len(name) <= max and len(name) > 2
      if available:
        let a = await name.isAvailable()
        available = a
      if not available:
        unavails[name] = 0
      prospect = (name, available)
    embed.title = some(prospect.name)
    embed.color = some(3066993)
    discard await bot.api.editMessage(m.channel_id, botmsg.id, embed=some(embed))

waitFor bot.startSession()