
###
String helpers

###

module.exports =

  zeroPad: (value, padding) ->
    zeroes = '0'
    zeroes += '0' for i in [ 1..padding ]
    (zeroes + value).slice padding * -1
