Cylon = require('cylon')

# Available values (0-100)
speed = 75
backlight = 0
# Number of seconds
timeToRoll = 1
# Degree (0-360)
heading = 0

# Key Event Function
workFunc = (my) ->
    stdin = process.openStdin()
    process.stdin.setEncoding('utf8')
    process.stdin.setRawMode(true)

    stdin.on 'data', (chunk, key) ->
        keyHandler my, chunk, key
        return

# Run for x seconds, change colors then come back and turn blue
# Set timeToRoll to desired length of time to reach target
flirt = (my) ->
    speed = 100
    timeToRoll = 5
    time = timeToRoll

    # Immediately run
    my.sphero.setColor 'white'
    my.sphero.roll speed, 0

    after (time).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'hotpink'
    time += .1
    after (time).second(), ->
        my.sphero.setColor 'red'
    time += .2
    after (time).second(), ->
        my.sphero.setColor 'hotpink'
    time += .3
    after (time).second(), ->
        my.sphero.setColor 'red'
    time += .4
    after (time).second(), ->
        my.sphero.roll speed, 180
    time += timeToRoll
    after (time).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'blue'

# Draws ng-conf logo
angularRulz = (my) ->
    speed = 70
    innerSide = 1.6
    shortSide = 2
    longSide = 1.33043478
    timeToRoll = shortSide

    return if fired
    fired = true

    # Start moving immediately & Draw the outer hexagon
    my.sphero.setColor 'gold'
    my.sphero.roll speed, 300 #bottom of yellow

    after (timeToRoll).second(), -> # stop at 1s
        my.sphero.stop()
        my.sphero.roll speed, 353 #top of yellow
        return

    after (timeToRoll + shortSide * longSide).second(), -> # stop at 2.33s
        my.sphero.stop()
        my.sphero.setColor 'steelblue'
        my.sphero.roll speed, 70 #left of blue
        return

    timeToRoll += shortSide * longSide
    after (timeToRoll + shortSide).second(), -> # stop at 3.33s
        my.sphero.stop()
        my.sphero.setColor 'midnightblue'
        my.sphero.roll speed, 109 #right of blue
        return

    timeToRoll += shortSide
    after (timeToRoll + shortSide).second(), -> # stop at 4.33s
        my.sphero.stop()
        my.sphero.setColor 'darkgreen'
        my.sphero.roll speed, 187 #top of green
        return

    timeToRoll += shortSide
    after (timeToRoll + shortSide * longSide).second(), -> # stop at 5.66s
        my.sphero.stop()
        my.sphero.roll speed, 240 #bottom of green
        return

    timeToRoll += shortSide
    after (timeToRoll + shortSide).second(), -> # stop at 6.66s
        my.sphero.stop()
        return

    timeToRoll += shortSide

    # Stop for .5s before drawing inner red shield
    after (timeToRoll + .5).second(), -> # stop at 6.71s
        my.sphero.roll speed, 0 #roll inside

    timeToRoll += .5
    after (timeToRoll + .2).second(), -> #stop at 6.86s
        my.sphero.stop()
        my.sphero.setColor 'red'
        my.sphero.roll speed, 300 #bottom of yellow
        return

    timeToRoll += .2
    after (timeToRoll + innerSide).second(), -> # stop at 8.66s
        my.sphero.stop()
        my.sphero.roll speed, 353 #top of yellow
        return

    after (timeToRoll + innerSide * longSide).second(), -> # stop at 11.05
        my.sphero.stop()
        my.sphero.roll speed, 70 #left of blue
        return

    timeToRoll += innerSide * longSide
    after (timeToRoll + innerSide).second(), -> # stop at 12.85
        my.sphero.stop()
        my.sphero.setColor 'maroon'
        my.sphero.roll speed, 109 #right of blue
        return

    timeToRoll += innerSide
    after (timeToRoll + innerSide).second(), -> # stop at 14.65
        my.sphero.stop()
        my.sphero.roll speed, 187 #top of green
        return

    timeToRoll += innerSide
    after (timeToRoll + innerSide * longSide).second(), -> # stop at 17.04s
        my.sphero.stop()
        my.sphero.roll speed, 240 #bottom of green
        return

    timeToRoll += innerSide
    after (timeToRoll + innerSide).second(), -> # stop at 18.84s
        my.sphero.stop()
        return

    fired = false
    return


# Set keyboard commands, which runs different functions
keyHandler = (my, chunk, key) ->
    switch chunk

        # Stop & Exit
        when 'x'
            my.sphero.stop()
            process.exit()
            return

        # Turn backlight on/off
        when 'b'
            if backlight is 0
                backlight = 100
            else
                backlight = 0
            my.sphero.setBackLED backlight

        # Change Sphero Colors
        when '1'
            my.sphero.setColor 'lime'
        when '2'
            my.sphero.setColor 'blue'
        when '3'
            my.sphero.setColor 'magenta'
        when '4'
            my.sphero.setColor 'cyan'
        when '5'
            my.sphero.setColor 'darkmagenta'
        when '6'
            my.sphero.setColor 'orange'
        when '7'
            my.sphero.setColor 'yellow'
        when '8'
            my.sphero.setColor 'red'
        when '9'
            my.sphero.setColor 'darkgray'
        when '0'
            my.sphero.setColor 'black'

        # Drive Sphero
        when 'd'
            my.sphero.roll speed, heading

        # Stop Sphero
        when ' '
            my.sphero.stop()

        # Down Arrow
        # Rolls backwards
        when "\u001b[B"
            my.sphero.roll speed, 180

        # Right Arrow
        # Changes heading by +15 degrees
        when "\u001b[C"
            if heading is 360
                heading = 0
            else
                heading += 15
            console.log heading
            my.sphero.roll 0, heading

        # Left Arrow
        # Changes heading by -15 degrees
        when "\u001b[D"
            if heading is 0
                heading = 345
            else
                heading -= 15
            console.log heading
            my.sphero.roll 0, heading

        # Flirt Function
        when 'f'
            flirt my

        # Angular Function
        when 'a'
            angularRulz my

    return

# Connect to sphero
# Port will be different for different sphereo's
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
