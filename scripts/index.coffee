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
firebase = require('./firebase')
CronJob = require('cron').CronJob
moment = require('moment')

module.exports = (robot) ->
  robot.respond /(.*)information?/i, (msg) ->
    msg.send "Firebase backup service of course! I ain't yo mamma fool"

  robot.respond /how big is firebase?/i, (msg) ->
    firebase.size (err, result) ->
      if err
        msg.send "An error occured"
      else
        msg.send "#{result}"

  robot.respond /backup firebase/i, (msg) ->
    firebase.backup (err, result) ->
      if err
        msg.send "Something went wrong! #{err.message}"
      else
        today = moment(new Date()).format('YYYY-MM-DD')
        msg.send "#{today}: #{result} of data successfully backed up!"
    return

  # Weekly schedule (9pm every day)
  new CronJob('0 0 21 * * *', (->
    firebase.backup (err, result) ->
      if err
        robot.messageRoom "chatroomname", "Something went wrong! #{err.message}"
      else
        today = moment(new Date()).format('YYYY-MM-DD')
        robot.messageRoom "chatroomname", "#{today}: #{result} of data successfully backed up!"
    return
  ), null, true, 'America/New_York')