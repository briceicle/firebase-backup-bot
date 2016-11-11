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

module.exports = (robot) ->
  robot.respond /(.*)info/i, (res) ->
    res.send 'Firebase Backup Bot'

  robot.respond /size/i, (res) ->
    robot.emit 'size', res

  robot.respond /backup/i, (res) ->
    robot.emit 'backup', res

  robot.respond /schedule (.*)/i, (res) ->
    robot.emit 'schedule', {
      res: res,
      pattern: res.match[1]
    }