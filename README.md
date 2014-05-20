Sphero
======

Hacks for Sphero using Cylon.js
Driver Documentation: http://cylonjs.com/documentation/drivers/sphero/
Sphero Documentation: http://orbotixinc.github.io/Sphero-Docs/

How To Start
============

+ enable bluetooth and connect to Sphero
+ `cd` into `Sphero` directory
+ install Coffee Script using Node.js `npm install -g coffee-script`
+ run `coffee sphero.coffee`
+ once your computer connects to sphero it will display `Driver sphero started`
+ use keyboard to run the different commands

Basic Commands
==============

+ `0-9` - changes color of the sphero
+ `b` - activates the backlight
+ `d` - rolls sphero to set heading
+ `spacebar` - stops sphero
+ `left arrow` - sets heading of sphero `-15` degrees
+ `right arrow` - sets heading of sphero `+15` degrees
+ `down arrow` - rolls sphero to opposite of set heading
+ `x` - exit and disconnect from sphero

Custom Commands
===============

+ `f` - runs **flirt** command, sphero rolls forward for specified seconds, flashes red and pink, then rolls back
+ `a` - runs **angular** command, sphero draws the ng-conf logo
