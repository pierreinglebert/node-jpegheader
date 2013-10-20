fs = require "fs"
async = require "async"

module.exports = class JpegHeaderParser
  position: 0
  fd: null
  constructor: (@file) ->
  getInfos: (cb) ->
    if typeof @file isnt "string"
      # Directly an file descriptor
      @fd = @file
      @examine()
    else
      fs.open(@file, "r", (err, fd) =>
        if err
          cb err
        else
          @fd = fd
          @examine(cb)
      )

  examine: (done)->
    #Check SOI
    self = this
    async.series(
      soi: (next) ->
        self.readInt((err, code) ->
          #Must be a FFDA
          unless err
            if code isnt 65496
              next(new Error "Incorrect header SOI")
            else
              next err
        )
      infos: (next) ->
        self.position+=2
        self.readFrame(next)
    , (err, res) ->
      done(err, res.infos)
    )

  read:(buffer, length, cb) ->
    fs.read(@fd, buffer, 0, length, @position, cb)

  readInt:(cb) ->
    buffer = new Buffer(2)
    this.read(buffer, 2, (err, bytesRead, buffer) ->
      if err
        cb(err)
      else
        cb(null, buffer.readUInt16BE(0))
    )

  readChar:(cb) ->
    buffer = new Buffer(1)
    this.read(buffer, 1, (err, bytesRead, buffer) ->
      if err
        cb(err)
      else
        cb(null, buffer.readUInt8(0))
    )

  readFrame: (done) ->
    # Frame is FF and a specific code
    # After there is a int of the frame length
    # So first, we take all these 3 codes
    self = @
    frame = {}
    async.series([
      (next) ->
        self.readChar((err, char) ->
          # Must be a FF
          unless err
            if char isnt 255
              next(new Error "Incorrect Frame Marker (FF)")
            else
              next err
        )
      (next) ->
        self.position++
        self.readChar((err, code) ->
          # Frame code
          unless err
            frame.code = code
            next()
          else next err
        )
      (next) ->
        self.position++
        self.readInt((err, length) ->
          # Frame length
          unless err
            frame.length = length
            next()
          else next err
        )
    ], (err) ->
      unless err
        switch frame.code
          when 0xC0,0xC1,0xC2,0xC3,0xC5,0xC6,0xC7,0xC9,0xCA,0xCB,0xCD,0xCE,0xCF
            self.readSof(frame, done)
          when 0xDA, 0xD9 #SOS Marker(end of header) or EOI (end of image)
            done(err)
          else
            self.position += frame.length
            self.readFrame(done)
      else
        done(err)
    )

  readSof: (frame, done) ->
    # Read length of frame
    buffer = new Buffer(frame.length)
    fs.read(@fd, buffer, 0, frame.length, @position, (err, bRead, buffer) =>
      #done null,
      done null,
        bits: buffer.readUInt8(2)
        height: buffer.readUInt16BE(3)
        width: buffer.readUInt16BE(5)
        components: buffer.readUInt8(7)
    )

