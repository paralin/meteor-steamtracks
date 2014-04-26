crypto = Npm.require "crypto"
class SteamTracks
  constructor: (@key, @secret)->
    
  hashPayload: (json)->
    return crypto.createHmac('sha1', @secret).update(json).digest('hex')
  sendRequest: (method, params)->
    json = EJSON.stringify params
    headers = {
      'ACCEPT': 'application/json'
      'Content-Type': 'application/json'
      'SteamTracks-Key': @key
      'SteamTracks-Signature': hashPayload json
      't': new Date().getTime()
    }
    HTTP.post 'https://steamtracks.com/api/v1/'+method, {data: json, headers: headers}

  listUsers: (page)->
    page = page || 1
    res = @sendRequest "users", {page: page}
    res.data.result
  userCount: ->
    res = @sendRequest "users/count"
    res.data.result.users
  userInfo: (steamID)->
    res = @sendRequest "users/info", {user: steamID}
    res.data.result.userinfo
  userStates: ->
    res = @sendRequest "users/states"
    res.data.result.userstates
  userGames: ->
    res = @sendRequest 'users/games'
    res.data.result.games
  leavers: ->
    res = @sendRequest "users/leavers"
    res.data.result.leavers
  flushLeavers: ->
    @sendRequest "users/flushleavers"
  changesSince: (from, fields)->
    res = @sendRequest "users/changes", {from_timestamp: from, fields: fields}
    res.data.result

  generateSignupToken:(steamID) ->
    res = @sendRequest "signup/token", {steamid32: steamID, return_steamid32: true}
    res.data.result.token
  getSignupStatus:(token)->
    res = @sendRequest "signup/status", {token: token}
    res.data.result
  ackSignupFinish: (token, user)->
    res = @sendRequest "signup/ack", {token: token, user: user}
    res.data.result
