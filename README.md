![](http://i1.cdnds.net/10/19/media_steam_logo.jpg)

SteamTracks API implementation for Meteor.

Installing
----------

`mrt add steamtracks`

Create the Instance
------------------

`stracks = new SteamTracks "mykey", "mysecret"`

Available Methods
-----------------

### hashPayload(json)

Utility method, hashes the string json payload for sending to SteamTracks.

###sendRequest (method, params)

Executes a raw API request.

###listUsers(page)

List of all users using the app.

###userCount()

Count users in the app.

###userInfo(steamID)

Information about a single user

###userStates()

Number of users in each state.

###userGames()

Number of users playing each game.

###leavers()

List of users that have left the app (deauthorized it)

###flushLeavers()

Clear the leavers list


###changesSince(fromTime, fields)

User changes since a date.

###generateSignupToken(steamID)

Generate a signup token for a steamID

###ackSignupFinish(token, userID)

Acknowledge the signup finished.
