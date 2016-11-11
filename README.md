# Firebase Backup Bot

> A simple bot to schedule automated backups of your Firebase data to Amazon S3.


## Scheduling
The bot reads cron patterns as arguments for scheduling.

The following slack command schedules a backup to run Monday to Friday at 9pm EST

- `schedule 00 30 11 * * 1-5`

[Read up on cron patterns here](http://crontab.org/). Note the examples in the link have five fields, and 1 minute as the finest granularity, but the library used by the bot has six fields, with 1 second as the finest granularity.


## Notifications
A backup confirmation is posted on Slack in your desired slack channel.

## File naming
Files transferred to your Amazon AWS bucket will be timestamped (ISO 8601 standard) and use the following naming conventions:

- Database data: `YYYY-MM-DDTHH:MM:SSZ_<DATABASE_NAME>_data.json`

## Environment Variables

### Amazon AWS
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_BUCKET_NAME`
- `AWS_REGION`

### Firebase
- `FIREBASE_DB_URL`
- `FIREBASE_DB_NAME`

### Google
- `PATH_TO_SERVICE_ACCOUNT_KEY`

### Slack
- `HUBOT_SLACK_TOKEN`
- `HUBOT_SLACK_CHANNEL`

## Test the bot
- `HUBOT_SLACK_TOKEN=<your-slack-token> bin/hubot -a slack`

## Contribute

Contribute by adding more cool commands to the bot
