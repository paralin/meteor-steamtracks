crypto = Npm.require "crypto"
class SteamTracks
  constructor: (@key, @secret, debug)->
    @debug = debug? && debug is true
    
  hashPayload: (json)->
    return crypto.createHmac('sha1', @secret).update(json).digest('base64')
  sendRequest: (usePOST, method, params)->
    params = params || {}
    params["t"] = Math.round(new Date().getTime() / 1000)
    json = EJSON.stringify params
    signature = @hashPayload json
    headers = {
      'ACCEPT': 'application/json'
      'Content-Type': 'application/json'
      'SteamTracks-Key': @key
      'SteamTracks-Signature': signature
    }
    url = 'https://steamtracks.com/api/v1/'+method
    console.log "SteamTracks request, url #{url}, headers #{headers}, data #{json}, signature #{signature}." if @debug
    options = {headers: headers}
    if usePOST
      options["content"] = json
    else
      options["data"] = {payload: json}
    HTTP.call (if usePOST then "POST" else "GET"), url, options

  listUsers: (page)->
    page = page || 1
    res = @sendRequest false, "users", {page: page}
    res.data.result
  userCount: ->
    res = @sendRequest false, "users/count"
    res.data.result.users
  userInfo: (steamID)->
    res = @sendRequest false, "users/info", {user: steamID}
    res.data.result.userinfo
  userStates: ->
    res = @sendRequest false, "users/states"
    res.data.result.userstates
  userGames: ->
    res = @sendRequest false, 'users/games'
    res.data.result.games
  leavers: ->
    res = @sendRequest false, "users/leavers"
    res.data.result.leavers
  flushLeavers: ->
    @sendRequest true, "users/flushleavers"
  changesSince: (from, fields)->
    res = @sendRequest false, "users/changes", {from_timestamp: from, fields: fields}
    res.data.result

  generateSignupToken:(steamID) ->
    options = {return_steamid32: true}
    options["steamid32"] = steamID if steamID?
    res = @sendRequest false, "signup/token", options
    res.data.result.token
  getSignupStatus:(token)->
    res = @sendRequest false, "signup/status", {token: token}
    res.data.result
  ackSignupFinish: (token, user)->
    res = @sendRequest true, "signup/ack", {token: token, user: user}
    res.data.result
