10 memory &7FFF
20 load"asm2err"
30 on error goto 200
40 for i%=0 to 33
50 if i%=31 then print "== Errors 31 and above are custom. =="
60 print "Error";i%;"... ";
70 call &8000,i%
80 next
90 list
200 print "caught";ERR;"on line";ERL : resume next
