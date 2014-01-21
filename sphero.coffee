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
    speed = 40
    timeToRoll = 5
    time = timeToRoll

    # Immediately run
    my.sphero.setColor 'white'
    my.sphero.roll speed, 0

    after (time).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'hotpink'
    time += 0.1
    after (time).second(), ->
        my.sphero.setColor 'red'
    time += 0.2
    after (time).second(), ->
        my.sphero.setColor 'hotpink'
    time += 0.3
    after (time).second(), ->
        my.sphero.setColor 'red'
    time += 0.4
    after (time).second(), ->
        my.sphero.roll speed, 180
    time += timeToRoll
    after (time).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'blue'

# Draws ng-conf logo
angularRulz = (my) ->
    speed = 40
    innerShortSide = 0.63716814
    innerLongSide = 0.88495575
    thickness = 0.38053097
    shortSide = 2
    longSide = 1.36283186
    timeToRoll = shortSide

    return if fired
    fired = true

    # Start moving immediately & Draw the outer hexagon
    # Bottom of Yellow
    my.sphero.setColor 'gold'
    my.sphero.roll speed, 300

    # Top of Yellow
    after (timeToRoll).second(), ->
        my.sphero.stop()
        my.sphero.roll speed, 353
        return

    # Left of Blue
    after (timeToRoll + shortSide * longSide).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'steelblue'
        my.sphero.roll speed, 70
        return

    # Right of Blue
    timeToRoll += shortSide * longSide
    after (timeToRoll + shortSide).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'midnightblue'
        my.sphero.roll speed, 109
        return

    # Top of Green
    timeToRoll += shortSide
    after (timeToRoll + shortSide).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'darkgreen'
        my.sphero.roll speed, 187
        return

    # Bottom of Green
    timeToRoll += shortSide
    after (timeToRoll + shortSide * longSide).second(), ->
        my.sphero.stop()
        my.sphero.roll speed, 240
        return

    # Starting Point
    timeToRoll += shortSide
    after (timeToRoll + shortSide).second(), ->
        my.sphero.stop()
        return

    timeToRoll += shortSide

    # Stop for .5s before drawing inner red shield
    # Roll to inside
    after (timeToRoll + 0.5).second(), ->
        my.sphero.roll speed, 0

    # Bottom of Yellow
    timeToRoll += 0.5
    after (timeToRoll + thickness).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'red'
        my.sphero.roll speed, 300
        return

    # Top of Yellow
    timeToRoll += thickness
    after (timeToRoll + innerShortSide * shortSide).second(), ->
        my.sphero.stop()
        my.sphero.roll speed, 353
        return

    # Left of Blue
    after (timeToRoll + innerLongSide * innerLongSide).second(), ->
        my.sphero.stop()
        my.sphero.roll speed, 70
        return

    # Right of Blue
    timeToRoll += innerLongSide * innerLongSide
    after (timeToRoll + innerShortSide * shortSide).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'maroon'
        my.sphero.roll speed, 109
        return

    # Top of Green
    timeToRoll += innerShortSide * shortSide
    after (timeToRoll + innerShortSide * shortSide).second(), ->
        my.sphero.stop()
        my.sphero.roll speed, 187
        return

    # Bottom of Green
    timeToRoll += innerShortSide * shortSide
    after (timeToRoll + innerLongSide * innerLongSide).second(), ->
        my.sphero.stop()
        my.sphero.roll speed, 240
        return

    # Stop at starting point
    timeToRoll += innerShortSide * shortSide
    after (timeToRoll + innerShortSide * shortSide).second(), ->
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
            if heading < 180
                heading += 180
            else
                heading -= 180
            my.sphero.roll speed, heading

        # Right Arrow
        # Changes heading by +15 degrees
        when "\u001b[C"
            if heading is 360
                heading = 0
            else
                heading += 15
            my.sphero.roll 0, heading

        # Left Arrow
        # Changes heading by -15 degrees
        when "\u001b[D"
            if heading is 0
                heading = 345
            else
                heading -= 15
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
