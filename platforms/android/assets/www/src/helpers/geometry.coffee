module.exports =

  radToDeg: (rad) -> return rad * ( 180 / Math.PI )

  degToRad: (deg) -> return deg * ( Math.PI / 180 )

  degToVector: (deg, force = 1) ->
    rad = @degToRad deg
    vector =
      x: force * Math.cos rad
      y: force * Math.sin rad
    return vector

  getDistance: (a, b) ->
    xs = b.x - a.x
    xs = xs * xs

    ys = b.y - a.y
    ys = ys * ys

    return Math.abs Math.sqrt xs + ys

  sumVectors: (vectors) ->
    anglesSumX = 0
    anglesSumY = 0
    forceSum = 0

    for vector in vectors
      deg = Math.atan2 vector.y, vector.x
      anglesSumX += Math.cos deg
      anglesSumY += Math.sin deg

      forceSum += Math.abs(vector.x) + Math.abs(vector.y)

    angleDeg = Math.floor @radToDeg Math.atan2 anglesSumY, anglesSumX
    force = forceSum
    return @degToVector angleDeg, force

  rectanglesIntersect: (a, b) ->
    return not (b.x > a.x + a.width or b.x + b.x + b.width < a.x or b.y > a.y + a.height or b.y + b.height < a.y)