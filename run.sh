#!/bin/bash


# Funzione di backup
function check_devices {
	clear && reset
    echo Avvio Wear Re-pairing
    echo --------------------
    echo "          ______           _     ___                      "
    echo "         |  ____|         | |   / _ \                     "
    echo "         | |__  __ _  ___ | |_ | | | | _ __               "
    echo "         |  __|/ _  |/ __|| __|| | | || '_ \              "
    echo "         | |  | (_| |\__ \| |_ | |_| || | | |             "
    echo "         |_|   \__,_||___/ \__| \___/ |_| |_|             "
    echo "                                                          "
    echo "                __  _                                     "
    echo "               / _|| |                                    "
    echo "   ___   ___  | |_ | |_ __      __ ____  ____  ___        "
    echo "  / __| / _ \ |  _|| __|\ \ /\ / // _  ||  __|/ _ "'\'"   "
    echo "  "'\'"__ \| |_| || |  | |_  \ V  V /| (_| || |  |  __/   "
    echo "  |___/ \___/ |_|   \__|  \_/\_/  \____||_|   \___|       "
    echo "                                                          "
    sleep 2
    clear

    # Kill-server (Android <= 6.0)
    ./$1/adb kill-server 1>/dev/null

    # Reboot adb
    ./$1/adb start-server 1>/dev/null

    # Check Android found
    check=$(./$1/adb devices)
}


# Menu principale
function display_menu {
    
    clear
    echo "Attivo la modalità aereo"
    ./$1/adb shell settings put global airplane_mode_on 1
    sleep 1
    echo ""
    echo "Elimino i file del GMS ed eseguo un reboot"
    sleep 1
    ./$1/adb shell "pm clear com.google.android.gms && reboot"
    sleep 1
    echo ""
    echo "Aspetto che Wear si accenda"
    sleep 60
    echo "Rendo visibile il bluetooh e disattivo la modalità aereo"
    ./$1/adb shell am start -a android.bluetooth.adapter.action.REQUEST_DISCOVERABLE
    ./$1/adb shell settings put global airplane_mode_on 0

}

## Main
# Controllo sistema
if [[ "$OSTYPE" == "linux-gnu" ]]
then
    # Linux
    MACHINE_TYPE=`uname -m`

    if [ ${MACHINE_TYPE} == 'x86_64' ]
    then
        # 64-bit
        check_devices 'linux'
        display_menu 'linux'
    # TODO Potrebbe entrare qui in caso di sistema non riconosciuto, mettere if
    else
        # 32-bit
        check_devices 'linux32'
        display_menu 'linux32'
    fi

    elif [[ "$OSTYPE" == "darwin"* ]]
    then
        # Mac OS
        check_devices 'macos'
        display_menu 'macos'
    else
        echo Sistema non riconosciuto...
fi