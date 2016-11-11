# Description:
#   Script that schedules backups.

CronJob = require('cron').CronJob

# Schedule a cron job
schedule = (pattern, callback) ->
  try
    new CronJob(pattern, (->
      robot.emit 'backup', null
    ), null, true, 'America/New_York')
    callback(true)
  catch ex
    callback(false)


module.exports = (robot) ->
  robot.on 'schedule', (obj) ->
    res = obj.res
    pattern = obj.pattern
    msg = null

    schedule pattern, (valid) ->
      if valid
        msg = 'Next backup scheduled!'
      else
        msg = 'Invalid Cron Pattern'
      
      robot.emit 'done', {
        res: res,
        msg: msg
      }
