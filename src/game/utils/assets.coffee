
###
## Assets module

Serves assets filenames depending on configuration and device pixel density
###

device = require '../../core/device'

# Device pixel ratio
pr = device.getPixelRatio()

config =
  suffix: if pr is 1 then '' else "@#{pr}x"     # Assets suffix depends on device pixel ratio
  assetsDir: 'assets'                           # Assets root path
  ext: 'png'                                    # Assets extension

module.exports =

    getAssetPath: (asset, ext = ext) -> "#{config.assetsDir}/#{asset}#{config.suffix}.#{config.ext}"
