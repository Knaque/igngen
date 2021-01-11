import httpclient, strformat, asyncdispatch

proc isAvailable*(name: string): Future[bool] {.async.} =
  var client = newAsyncHttpClient()
  var response = await client.get(fmt"https://api.mojang.com/users/profiles/minecraft/{name}")
  return response.code == Http204