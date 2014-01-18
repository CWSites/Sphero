Sphero
======

Hacks for Sphero using Cylon.js
Driver Documentation: http://cylonjs.com/documentation/drivers/sphero/

How To Start
============

+ `cd` into `sphero` directory
+ run `coffee sphero.coffee`
+ once your computer connects to sphero it will display `Driver sphero started`
+ use keyboard to run the different commands

Basic Commands
==============

+ `0-9` - changes color of the sphero
+ 'd' - rolls sphero to set heading
+ `x` - exit and disconnect from sphero
+ 'spacebar' - stops sphero
+ *left arrow* - sets heading of sphero -15 degrees
+ *right arrow* - sets heading of sphero +15 degrees

Custom Commands
===============

+ `f` - runs "flirt" command, sphero rolls forward for specified seconds, flashes red and pink, then rolls back
+ `a` - runs "angular" command, sphero draws the ng-conf logo
