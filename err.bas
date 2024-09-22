10 memory &7FFF
20 load"asm2err"
30 print "Enter an error number between 1 and 30."
40 input i%
50 print "Will raise error"; i%;
60 print "You can also: call &8000," ; i%
70 call &8000,i%
80 print "This is never run"
