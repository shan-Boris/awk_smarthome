function numberRoomIsNotValid(num) {
    return num < 0 || num > 9
}

# where - указать откуда вызов window/cooler
function alarmIsOn(where) {
    if (home[10] == 1) {
        print where " error: alarm enabled";    
        return 1
    }
}

function isNotValidNumberWindow(room) {
    if(numberRoomIsNotValid(room)) {
        print "window error: room must be between 0 and 9"
        return 1
    }
}

function isNotValidTemp(temp) {
    if (temp < 18 || temp > 26) {
        print "cooler error: temp must be between 18 and 26";
        return 1
    }
}

function isNotValidNumberCooler(room) {
    if(numberRoomIsNotValid(room)) {
        print "cooler error: room must be between 0 and 9"
        return 1
    }
}

function openWindow(room) {
    if(isNotValidNumberWindow(room)) return
    if(alarmIsOn("window")) return

    if(home[room] == closedWindow) {
        home[room] = openedWindow;
        print "success: window " room " opened"    
    }else if(home[room] != openedWindow) {
        print "window error: cooler " room " enabled" 
    }else {
        print "window error: " room " already opened"
    }     
}

function closeWindow(room) {
    if(isNotValidNumberWindow(room)) return
    if(alarmIsOn("window")) return

    if(home[room] == openedWindow) {
        home[room] = closedWindow;
        print "success: window " room " closed"    
    }else {
        print "window error: " room " already closed" 
    }
}

function setTempOnCooler(room, deg) {
    if(isNotValidNumberCooler(room)) return
    temp = int(deg)
    if(isNotValidTemp(temp)) return
    if(alarmIsOn("cooler")) return

    if(home[room] == openedWindow) {
        print "cooler error: window " room " opened"
    } else {
        home[room] = "["temp"]"
        print "success: cooler " room " set to "temp
    }
}

function coolerOff(room) {
    if(isNotValidNumberCooler(room)) return
    if(alarmIsOn("cooler")) return

    if(home[$2] == closedWindow || home[$2] == openedWindow) {
        print "cooler error: " $2 " already off"
    } else {
        home[$2] = closedWindow;
        print "success: cooler " $2 " disabled";
    }       
}

function alarmOff() {
    if(home[10] == 0) {
        print "alarm error: already disabled";
        return
    } 

    home[10] = 0;
    print "success: alarm disabled" 
}

function alarmOn() {
    if(home[10] == 1) {
        print "alarm error: already enabled"
        return
    }
    
    # проверяем все окна и кондиционеры, запоминаем первые открытые/вкл
    windowIsOpen = -1;
    coolerIsWork = -1;
    for(i = 0; i < 10; i++) {
        if(home[i] == openedWindow) {
            windowIsOpen = i;
            break;
        }else if (home[i] != closedWindow && coolerIsWork == -1){ 
            coolerIsWork = i; 
        }
    }
    if(windowIsOpen != -1) {
        print "alarm error: window " windowIsOpen " opened"
        return	
    }
    if (coolerIsWork != -1) {
        print "alarm error: cooler " coolerIsWork " enabled"
        return
    }
    home[10] = 1;
    print "success: alarm enabled" 
}


BEGIN {	
    closedWindow = "[  ]";
    openedWindow = "[\\/]";
    home[10] = 1; # инициализация состояние сигнализации
    for (i = 0; i < 10; i++) { 
        home[i] = closedWindow;}
    } # инициализация состояния окон
    # массив home и графические состояния окна оставил глобальными, 
    # т.к. многократно используется всем скриптом

/^stat$/ {
    printf home[10];
    for(i = 0; i < 10; i++) {
        if(i == 9) {
            print home[i]
        }else { 
            printf home[i] 
        }
    }; next
}

/^window [0-9]+ open$/ {
    openWindow($2); next
}

/^window [0-9]+ close$/ {
    closeWindow($2); next
}

/^cooler [0-9]+ (-?[0-9]+C)$/ {
    setTempOnCooler($2, $3); next
}

/^cooler [0-9]+ off$/ {
    coolerOff($2); next
}

/^alarm off$/ {
    alarmOff(); next
}

/^alarm on$/ {
    alarmOn(); next
}


/^\s*$/ {
    print; next
}

/^#/ {
    print $0; next
}

/.*/ {
    print "error: unknown command"; next
}

END {}
