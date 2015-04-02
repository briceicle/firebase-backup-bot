# Description:
#   Allows hubot to run commands.
#
# Commands:
#   how big is firebase: Display the size of Firebase data
#   backup firebase: Trigger a firebase backup to S3 and display confirmation
#
# Author:
#   andela-bnkengsa

_ = require("lodash")
filesize = require('filesize')
firebase = require('./firebase')
CronJob = require('cron').CronJob
moment = require('moment')

module.exports = (robot) ->
  robot.respond /(.*)information?/i, (msg) ->
    msg.send "Firebase backup service of course! I ain't yo mamma fool"

  robot.respond /how big is firebase?/i, (msg) ->
    firebase.size (err, bytes) ->
      if err
        msg.send "An error occured"
      else
        size = filesize(bytes)
        msg.send "#{size}"

  robot.respond /backup firebase/i, (msg) ->
    firebase.backup (err, result) ->
      if err
        msg.send "Something went wrong! #{err.message}"
      else
        today = moment(new Date()).format('YYYY-MM-DD')
        size = filesize(result)
        msg.send "#{today}: #{size} of data successfully backed up!"
    return

  # Weekly schedule (9pm every day)
  new CronJob('0 0 21 * * *', (->
    firebase.backup (err, result) ->
      if err
        robot.messageRoom "chatroomname", "Something went wrong! #{err.message}"
      else
        today = moment(new Date()).format('YYYY-MM-DD')
        size = filesize(result)
        robot.messageRoom "chatroomname", "#{today}: #{size} of data successfully backed up!"
    return
  ), null, true, 'America/New_York')