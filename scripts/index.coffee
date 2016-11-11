# Description:
#   Script listens to user commands.
#
# Commands:
#   info: Display the name of the bot
#   size: Display the size of Firebase data
#   backup: Trigger a firebase backup to S3 and display confirmation
#
# Author:
#   andela-bnkengsa

_ = require('lodash')
firebase = require('./firebase')
CronJob = require('cron').CronJob
moment = require('moment')

module.exports = (robot) ->
  robot.respond /(.*)info/i, (res) ->
    res.send 'Firebase Backup Bot'

  robot.respond /size/i, (res) ->
    robot.emit 'size', res

  robot.respond /backup/i, (res) ->
    robot.emit 'backup', res

  # Weekly schedule (9pm every day)
  new CronJob('0 0 21 * * *', (->
    robot.emit 'backup', null
  ), null, true, 'America/New_York')