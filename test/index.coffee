Require = require('covershot').require.bind(null, require)

chai = require "chai"
assert = chai.assert
expect = chai.expect
path = require "path"

JpegHeaderParser = Require "../lib/jpegparser"

describe('JpegHeaderParser', ->

  describe('getInfos',->
    it('should detect Grayscale 8 bit jfif jpeg', (done) ->
      imagePath = path.join(__dirname, "fixtures/jpeg400jfif.jpg")
      jpegParser = new JpegHeaderParser imagePath
      jpegParser.getInfos((err, res) ->
        assert.isNull err
        assert.isObject res
        assert.equal res.bits, 8
        assert.equal res.components, 1
        done()
      )
    )
    it('should detect RGB 8 bit jpeg', (done) ->
      imagePath = path.join(__dirname, "fixtures/jpeg444.jpg")
      jpegParser = new JpegHeaderParser imagePath
      jpegParser.getInfos((err, res) ->
        assert.isNull err
        assert.isObject res
        assert.equal res.bits, 8
        assert.equal res.components, 3
        done()
      )
    )
    it('should detect CMYK 8 bit jfif jpeg', (done) ->
      imagePath = path.join(__dirname, "fixtures/jpeg444_cmyk.jpg")
      jpegParser = new JpegHeaderParser imagePath
      jpegParser.getInfos((err, res) ->
        assert.isNull err
        assert.isObject res
        assert.equal res.bits, 8
        assert.equal res.components, 4
        done()
      )
    )
    it('should throw error with a tif file', (done) ->
      imagePath = path.join(__dirname, "fixtures/jpeg444_cmyk.tif")
      jpegParser = new JpegHeaderParser imagePath
      jpegParser.getInfos((err, res) ->
        assert.isNotNull err
        done()
      )
    )
    it('should throw error with an empty file', (done) ->
      imagePath = path.join(__dirname, "fixtures/empty.jpg")
      jpegParser = new JpegHeaderParser imagePath
      jpegParser.getInfos((err, res) ->
        assert.isNotNull err
        done()
      )
    )
    it('should throw error with an inexistant file', (done) ->
      imagePath = path.join(__dirname, "fixtures/donotexist.jpg")
      jpegParser = new JpegHeaderParser imagePath
      jpegParser.getInfos((err, res) ->
        assert.isNotNull err
        done()
      )
    )
  )

  describe('getExif',->
    it('should detect Grayscale 8 bit jfif jpeg', (done) ->
      imagePath = path.join(__dirname, "fixtures/exif.jpg")
      jpegParser = new JpegHeaderParser imagePath
      jpegParser.getInfos((err, res) ->
        assert.isNull err
        assert.isObject res
        assert.equal res.bits, 8
        assert.equal res.components, 1
        done()
      )
    )
  )
)