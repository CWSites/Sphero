Cylon = require('cylon')

SPEED = 75
backlight = 0

workFunc = (my) ->
    stdin = process.openStdin()
    process.stdin.setEncoding('utf8')
    process.stdin.setRawMode(true)

    stdin.on 'data', (chunk, key) ->
        keyHandler my, chunk, key
        return

# Run for 1.5 seconds, change colors then come back and turn blue
# Turning takes roughly 1 second so return movement should be 1 sec longer
flirt = (my) ->
    after (2).second(), ->
        my.sphero.roll SPEED, 0
    after (3.5).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'deeppink'
    after (4.5).second(), ->
        my.sphero.setColor 'red'
    after (5).second(), ->
        my.sphero.setColor 'deeppink'
    after (5.5).second(), ->
        my.sphero.setColor 'red'
    after (6).second(), ->
        my.sphero.roll SPEED, 180
    after (8.5).second(), ->
        my.sphero.stop()
        my.sphero.setColor 'blue'




#listens to keyevents
keyHandler = (my, chunk, key) ->
    switch chunk
        when 'x'
            my.sphero.stop()
            process.exit()
            return
        when 'b'
            if backlight is 0
                backlight = 100
            else
                backlight = 0
            my.sphero.setBackLED backlight
        when ' '
            my.sphero.stop()
        when "\u001b[C" #right
            my.sphero.roll SPEED, 90
        when "\u001b[B" #back
            my.sphero.roll SPEED, 180
        when "\u001b[D" #left
            my.sphero.roll SPEED, 270
        when 'g'
            flirt my

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
