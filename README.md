# Firebase Backup Bot

> A simple bot to schedule automated backups of your Firebase data to Amazon S3.


## Scheduling
Your Database backup is scheduled at 9pm EST every day.

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

### Test the bot
- `HUBOT_SLACK_TOKEN=<your-slack-token> bin/hubot -a slack

## Contribute

Contribute by adding more cool commands to the bot