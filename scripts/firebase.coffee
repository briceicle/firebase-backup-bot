async = require('async')
AWS = require('aws-sdk')
Firebase = require('firebase')
FirebaseTokenGenerator = require('firebase-token-generator')
moment = require('moment')

authenticateFirebase = (cb) ->
  rootRef = new Firebase('YOUR_FIREBASE_URL')
  tokenGenerator = new FirebaseTokenGenerator('YOUR_FIREBASE_TOKEN')
  token = tokenGenerator.createToken(
    uid: 'SOME_UID'
    name: 'backupbot')
  rootRef.authWithCustomToken token, (error, authData) ->
    if error
      cb error
    else
      cb null, rootRef
    return
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