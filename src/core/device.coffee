
###
## Device module

* Provides information about the device and makes adjustments for testing if specified
* Maps all click events to equivalent touch events and provides them to UI modules
###

win = $ window

# Popular mobile screen sizes and pixel densities for testing
testSizes =
  'galaxy-s3': [ 720, 1280, 2 ]
  'galaxy-s4': [ 1080, 1920, 3 ]
  'nexus-4': [ 768, 1280, 2 ]
  'iphone-4': [ 640, 920, 2 ]
  'iphone-5': [ 640, 1136, 2 ]
  'ipad-mini': [ 768, 1024, 2 ]

# If not null will fake specified resolution
# fakeSize = testSizes['iphone-5']

# Used to translate mouse events in touch events
touchEvents =
  click: "tap"
  mousedown: "touchstart"
  mousemove: "touchmove"
  mouseup: "touchend"

# Detect user agent
userAgent = ua = navigator.userAgent

# Detect if device is iOS
iOS = (ua.indexOf 'iPhone') isnt -1 or (ua.indexOf 'iPod') isnt -1 or (ua.indexOf 'iPad') isnt -1
iOS7 = iOS and (ua.indexOf 'OS 7') isnt -1

# Detect if is running as full-screen app
isStandAlone = window.navigator.standalone

# Detect if is running as full-screen app
isCordova = window.cordova

# Detect if using a supported mobile device
isMobile = if window.navigator.userAgent.match /(iPhone|iPod|iPad|Android|BlackBerry)/ then true else false

# Detect if using a touch device
isTouch = (_.has document.documentElement, 'ontouchstart') or (_.has window, 'onmsgesturechange')

# Should be true when testing on desktop devices with fakeSize selected
useFakeSize = fakeSize? and not isMobile

device =
  isMobile: isMobile                        # Returns true if supported touch device is detected
  size: null                                # Device screen size
  isTouch: isTouch                          # Is a touch device
  pixelRatio: window.devicePixelRatio or 1  # Device pixel ratio
  offset: x: 0, y: 0

# Updates screen size when device resizes
onResize = ->
  device.size =
    width: win.width()
    height: win.height()

  if iOS
    if isCordova
      if iOS7
        device.size.height -= 23
        device.offset.y += 23
    else if isStandAlone
      device.size.height -= 10
    else if iOS7
      ($ window).css overflow: 'hidden'
      device.size.height -= 105
    else
      device.size.height -= 60

win.on 'resize', onResize

# Executes once to populate device size
onResize()
module.exports =

  resize: onResize

  getPixelRatio: -> device.pixelRatio

  isTouch: -> device.isTouch

  isStandAlone: -> isStandAlone

  isFakeSize: -> fakeSize?

  getSize: ->
    if useFakeSize then return width: fakeSize[0] / fakeSize[2], height: fakeSize[1] / fakeSize[2]
    return device.size

  getOffset: -> device.offset or x: 0, y: 0

  getEvent: (evtType) -> if device.isTouch and (_.has touchEvents, evtType) then touchEvents[evtType] else evtType

  getCenter: -> x: device.size.width / 2, y: device.size.height / 2
