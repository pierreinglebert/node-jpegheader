JpegHeaderParser = require "./lib/jpegparser"

#Infos is a object that can include bits, width, height, components
module.exports.getInfos = (filepath, callback) ->
  jpegParser = new JpegHeaderParser filepath
  jpegParser.getInfos(callback)
