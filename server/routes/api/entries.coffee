express = require 'express'

Entry = require '../../models/entry'

module.exports = app = express()

app.route('/entries')
  .post (req, res) ->
    req.body.keywords = req.body.keywords?.split(',')
    newEntry = new Entry req.body
    
    newEntry.save (err, entry) ->
      if err
        res.send 400, err
      else
        res.send 200, entry

  .get (req, res) ->
    Entry.find {}, (err, entries) ->
      res.send 200, entries

app.route('/entries/:entryID')
  .get (req, res) ->
    Entry.findOne(_id: req.params.entryID).populate('bucket').exec (err, entry) ->
      if entry
        res.send entry
      else
        res.send 404
  .put (req, res) ->
    Entry.findOneAndUpdate {_id: req.params.entryID}, req.body, (err, entry) ->
      if err
        res.send 400, e: err
      else
        res.send 200, entry
  .delete (req, res) ->
    Entry.remove _id: req.params.userID, (err) ->
      if err
        res.send e: err, 400
      else
        res.send {}, 200

app.route('/entries/keywords')
  .get (req, res) ->
    Entry.distinct 'keywords', {}, (err, tags) ->
      res.send tags