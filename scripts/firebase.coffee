async = require('async')
AWS = require('aws-sdk')
admin = require('firebase-admin')
moment = require('moment')
env = require('dotenv')

# load the environment variables
env.config({silent: true})

authenticateFirebase = (cb) ->
  # Fetch the service account key JSON file contents
  serviceAccount = require(process.env.PATH_TO_SERVICE_ACCOUNT_KEY)

  # Initialize the app with a custom auth variable, limiting the server's access
  admin.initializeApp
    credential: admin.credential.cert(serviceAccount)
    databaseURL: process.env.FIREBASE_DB_URL
    databaseAuthVariableOverride: uid: 'firebase-backup-bot'

  db = admin.database()
  ref = db.ref('/')

  cb null, ref
  return

exportFirebaseData = (rootRef, cb) ->
  rootRef.once 'value', ((snap) ->
    data = snap.exportVal()
    cb null, data
    return
  ), (error) ->
    cb error
    return
  return

uploadtoS3 = (data, cb) ->
  date = new Date
  today = moment(date).format('YYYY-MM-DD')
  payload = JSON.stringify(data)
  AWS.config.region = 'us-east-1'
  s3 = new (AWS.S3)
  s3.createBucket { Bucket: 'firebase-backups' }, ->
    params =
      Bucket: 'firebase-backups'
      Key: today
      Body: payload
    s3.upload params, (err, data) ->
      bytes = Buffer.byteLength(payload, 'utf8')
      cb err, bytes
      return
    return
  return

module.exports = 
  backup: (cb) ->
    async.waterfall [
      authenticateFirebase
      exportFirebaseData
      uploadtoS3
    ], (err, result) ->
      if err
        cb(err)
      else
        cb(null, result)
  size: (cb) ->
    authenticateFirebase (err, rootRef) ->
      if err
        cb(err)
      rootRef.once 'value', (snap) ->
        data = JSON.stringify(snap.val());
        bytes = Buffer.byteLength(data, 'utf8')
        cb(null, bytes)