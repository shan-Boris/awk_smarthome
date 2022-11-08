IN='
# normal flow
stat
alarm off
stat
window 0 open
stat
window 9 open
stat
cooler 1 20C
stat
cooler 1 off
stat
window 0 close
stat
window 9 close
stat
alarm on
stat

# alarm errors
alarm
alarm xxx
alarm offf
alarm on
alarm off
alarm off
window 0 open
alarm on
window 0 close
cooler 1 20C
alarm on
cooler 1 off
alarm on
stat

# window errors
window
window -1 open
window 1
window 1 xxx
window xxx open
window 10 open
window 1 openn
alarm off
cooler 1 20C
window 1 open
cooler 1 off
window 1 open
window 1 open
window 1 close
window 1 close
alarm on
stat

# cooler errors
cooler
cooler -1 10C
cooler 1
cooler 1 xxx
cooler 1 -10C
cooler xxx 1
cooler 10 20C
cooler 1 10
cooler 1 10C
cooler 1 20C
alarm off
window 1 open
cooler 1 20C
window 1 close
cooler 1 off
cooler 1 off
alarm on
stat

# misc
stat 123
qwerty
123
close

# duplicates
alarm off
window 1 open
window 2 open
alarm on
window 1 close
window 2 close
cooler 1 20C
cooler 2 20C
alarm on
cooler 1 off
cooler 2 off
alarm on
'
OUT='
# normal flow
1[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
success: alarm disabled
0[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
success: window 0 opened
0[\/][  ][  ][  ][  ][  ][  ][  ][  ][  ]
success: window 9 opened
0[\/][  ][  ][  ][  ][  ][  ][  ][  ][\/]
success: cooler 1 set to 20
0[\/][20][  ][  ][  ][  ][  ][  ][  ][\/]
success: cooler 1 disabled
0[\/][  ][  ][  ][  ][  ][  ][  ][  ][\/]
success: window 0 closed
0[  ][  ][  ][  ][  ][  ][  ][  ][  ][\/]
success: window 9 closed
0[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
success: alarm enabled
1[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]

# alarm errors
error: unknown command
error: unknown command
error: unknown command
alarm error: already enabled
success: alarm disabled
alarm error: already disabled
success: window 0 opened
alarm error: window 0 opened
success: window 0 closed
success: cooler 1 set to 20
alarm error: cooler 1 enabled
success: cooler 1 disabled
success: alarm enabled
1[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]

# window errors
error: unknown command
error: unknown command
error: unknown command
error: unknown command
error: unknown command
window error: room must be between 0 and 9
error: unknown command
success: alarm disabled
success: cooler 1 set to 20
window error: cooler 1 enabled
success: cooler 1 disabled
success: window 1 opened
window error: 1 already opened
success: window 1 closed
window error: 1 already closed
success: alarm enabled
1[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]

# cooler errors
error: unknown command
error: unknown command
error: unknown command
error: unknown command
cooler error: temp must be between 18 and 26
error: unknown command
cooler error: room must be between 0 and 9
error: unknown command
cooler error: temp must be between 18 and 26
cooler error: alarm enabled
success: alarm disabled
success: window 1 opened
cooler error: window 1 opened
success: window 1 closed
cooler error: 1 already off
cooler error: 1 already off
success: alarm enabled
1[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]

# misc
error: unknown command
error: unknown command
error: unknown command
error: unknown command

# duplicates
success: alarm disabled
success: window 1 opened
success: window 2 opened
alarm error: window 1 opened
success: window 1 closed
success: window 2 closed
success: cooler 1 set to 20
success: cooler 2 set to 20
alarm error: cooler 1 enabled
success: cooler 1 disabled
success: cooler 2 disabled
success: alarm enabled
'
diff <(echo "$IN" | awk -f myscript.awk) <(echo "$OUT")