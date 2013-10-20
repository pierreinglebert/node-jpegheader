node-jpegheader
===============

* [![Build Status](https://secure.travis-ci.org/pierreinglebert/node-jpegheader.png)](http://travis-ci.org/pierreinglebert/node-jpegheader)
* [![Coverage Status](https://coveralls.io/repos/pierreinglebert/node-jpegheader/badge.png?branch=master)](https://coveralls.io/r/pierreinglebert/node-jpegheader?branch=master)
* [![Dependency Status](https://gemnasium.com/pierreinglebert/node-jpegheader.png)](https://gemnasium.com/pierreinglebert/node-jpegheader)

Fast extraction of jpeg informations (width/height/depth/colorspace)

Extract basic jpeg informations such as width, height, depth or colorpsace.
This was developped because imagemagick and other tools read all image data to get those header informations and for huge image (>100Mo), it takes several seconds...

## Usage
    
    jpegheader = require("jpegheader")
    jpegheader.getInfos("image.jpg", function(err, infos) {
    	//Infos is {width: 100, heigh: 120, bits: 8, components: 3}
    });

components is the number of channels in the image : 1 is for grayscale, 3 for RGB or YCbCr, 4 for CMYK

