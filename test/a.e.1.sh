IN='
stat
alarm on
'
OUT='
1[  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
alarm error: already enabled
'
diff <(echo "$IN" | awk -f myscript.awk) <(echo "$OUT")