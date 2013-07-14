
# Provides information about the device

# Popular mobile screen sizes and pixel densities for testing
testSizes =
  'galaxy-s3': [ 720, 1280, 2 ]
  'galaxy-s4': [ 1080, 1920, 3 ]
  'nexus-4': [ 768, 1280, 2 ]
  'iphone-4': [ 640, 920, 2 ]
  'iphone-5': [ 640, 1136, 2 ]

# If not null will fake specified resolution
fakeSize = testSizes['iphone-4']

# Used to translate mouse events in touch events
touchEvents =
  click: "tap"
  mousedown: "touchstart"
  mousemove: "touchmove"
  mouseup: "touchend"

# Detects if using a supported mobile device
isMobile = if window.navigator.userAgent.match /(iPhone|iPod|iPad|Android|BlackBerry)/ then true else false

# Detect if using a touch device
isTouch = (_.has document.documentElement, 'ontouchstart') or (_.has window, 'onmsgesturechange')

device =
  isTouch: isMobile       # Returns true if supported touch device is detected
  size: null              # Device screen size
  isTouch: isTouch        # Is a touch device

# Updates screen size when device resizes
onResize = -> device.size = width: $(window).innerWidth(), height: $(window).innerHeight()
$(window).on 'resize', onResize

# Executes once to populate device size
onResize()

module.exports =

  isTouch: -> device.isTouch

  getSize: ->
    if fakeSize? then return width: fakeSize[0] / fakeSize[2], height: fakeSize[1] / fakeSize[2]
    return device.size

  getEvent: (evtType) -> if device.isTouch and (_.has touchEvents, evtType) then touchEvents[evtType] else evtType

  getCenter: -> x: device.size.width / 2, y: device.size.height / 2
