env = require('dotenv')
env.config({silent: true})

module.exports = (robot) ->
  robot.on 'done', (obj) ->
    res = obj.res
    msg = obj.msg

    if res
      res.send msg
    else
      robot.messageRoom process.env.SLACK_CHANNEL, msg
