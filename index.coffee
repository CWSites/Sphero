Cylon = require('cylon')

count = 0
curAngle = 0
ANGLE_TO_MOVE = 12
SPEED = 75
TOTAL_CIRCLE = 400

keyHandler = (my, chunk, key) ->
    switch chunk
        when 'x'
            my.sphero.stop()
            process.exit()
            return
        when "s"
            my.sphero.setColor 'gold'
        when "a"
            my.sphero.setColor 'steelblue'
        when "d"
            my.sphero.setColor 'green'
        when 'w'
            my.sphero.setColor 'red'
        when ' '
            my.sphero.stop()
        when "\u001b[C" #right
            my.sphero.roll SPEED, 90
        when "\u001b[B" #back
            my.sphero.roll SPEED, 180
        when "\u001b[D" #left
            my.sphero.roll SPEED, 270
        when 'g'
            circleA my
        else
            my.sphero.roll SPEED, 0

    return

workFunc = (my) ->
    fired = false
    my.sphero.stop()
    my.sphero.detectCollisions(true)
    my.sphero.setRotationRate 50
    my.sphero.on 'collision', ->
        console.log 'collision'
        my.sphero.setColor 0x00BFFF
        my.sphero.stop()
        return

    stdin = process.openStdin()
    process.stdin.setEncoding('utf8')
    process.stdin.setRawMode(true)

    stdin.on 'data', (chunk, key) ->
        keyHandler my, chunk, key
        return

    return

circleA = (my) ->
    return if fired
    fired = true

    circleInterval = every (.25).second(), ->
        if  curAngle > TOTAL_CIRCLE
            clearInterval circleInterval
            my.sphero.stop()
            return

        my.sphero.roll SPEED, curAngle
        count++
        curAngle += ANGLE_TO_MOVE

    afirst = null
    totalTime = ((TOTAL_CIRCLE/ANGLE_TO_MOVE) * .25) + 2

    after totalTime.second(), ->
        SPEED -= 15
        my.sphero.setColor 'gold'
        my.sphero.roll SPEED, 110
        return

    after (totalTime+3).second(), ->
        my.sphero.stop()
        return

    after (totalTime + 5).second(), ->
        my.sphero.setColor('steelblue')
        my.sphero.roll SPEED, 220
        return

    after (totalTime + 8).second(), ->
        my.sphero.stop()
        return

    #  back to halfway for horizontal bar
    after (totalTime + 10).second(), ->
        my.sphero.roll SPEED, 40
        return

    after (totalTime + 11.5).second(), ->
        my.sphero.stop()
        return

    after (totalTime + 13.5).second(), ->
        my.sphero.setColor 'green'
        my.sphero.roll SPEED, 330
        return

    after (totalTime + 15.5).second(), ->
        my.sphero.setColor 'ghostwhite'
        my.sphero.stop()
        fired = false
        return

    return

settings =
    connection:
        name: 'sphero'
        adaptor: 'sphero'
        port: '/dev/cu.Sphero-RRW-AMP-SPP'
    device:
        name: 'sphero'
        driver: 'sphero'
    work: workFunc

Cylon.robot(settings).start()
