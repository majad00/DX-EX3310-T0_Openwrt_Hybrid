#!/bin/sh

# © 2019 Lifemote Bilisim ve Ticaret A.S. (LIFEMOTE), All rights reserved. All content including but not limited to text, graphics,
# logos, images, audio clips,  and software, is the exclusive property, including all right, title and interest therein, of LIFEMOTE
# alone, and which said content is protected by U.S. and international copyright laws, and may also be protected by U.S. and international
# patent laws. This protected content or any portion thereof may not be used, reproduced, duplicated, copied, sold, resold, or otherwise
# exploited for any purpose that is not expressly permitted in writing by LIFEMOTE, unless specifically noted.

# This software is provided by LIFEMOTE on an "as is" basis. LIFEMOTE makes no representations or warranties of any kind whatsoever,
# express or implied, as to the operation of the software or the information, content, materials, or products included thereon. To
# the full extent permissible by applicable law, other than what has been expressly agreed upon separately by LIFEMOTE in writing,
# all warranties, express or implied, including, but not limited to, implied warranties of merchantability and fitness for a
# particular purpose are disclaimed by LIFEMOTE. LIFEMOTE will not be liable for any damages of any kind arising from the use of
# this software, including, but not limited to direct, indirect, incidental, punitive, and consequential damages.

# ---------------------------------------------------------------------------------------------------------------------------------------

# Checks whether Lifemote agent script is running. Downloads and runs the script, if it is not running.
# If download fails waits for a random time before attempting to download again.
# URL for Lifemote script is assumed to be stored in an environment variable called LIFEMOTE_AGENT_URL

MAX_WAIT=60                # Timeout for curl (HTTP downloads) in seconds
BACKOFF_INTERVAL_BEGIN=300 # Starting value for backoff interval
BACKOFF_INTERVAL_MAX=7200  # Maximum value for backoff interval
CHECK_INTERVAL=1800        # Interval for checking whether the script is alive

if [ -z $LIFEMOTE_AGENT_URL ]; then
    echo "LIFEMOTE_AGENT_URL is not set. Exiting..."
    exit
fi

if [ -z $SCRIPT_PATH ]; then
    echo "SCRIPT_PATH is not set. Exiting..."
    exit
fi

fetch_and_run_script() {
    # Random backoff time is generated between PERIOD and 2*PERIOD
    # Initial value of PERIOD reset at each time this function is called
    PERIOD=$BACKOFF_INTERVAL_BEGIN
    
    rm $SCRIPT_PATH
    while true; do
        if curl --fail -m $MAX_WAIT $LIFEMOTE_AGENT_URL > $SCRIPT_PATH; then
            (sh $SCRIPT_PATH &)&
            break
        fi
        backoff=$(( PERIOD ))
        
        echo "Dowmload failed. Retry download after $backoff seconds..."
        
        sleep $backoff

        # PERIOD is doubled for each unsuccessful attempt up to BACKOFF_INTERVAL_MAX
        if [ $PERIOD -le $BACKOFF_INTERVAL_MAX ]; then
            PERIOD=$(( PERIOD * 2 ))
        fi
    done
}

cleanup() {
    echo "Cleaning up..."
    psout=$(ps)
    lifemote_processes=$(echo "$psout" | grep "$SCRIPT_NAME" | grep -v $$) 
    echo "$lifemote_processes" | while read line;
    do
        pid=$(echo $line | cut -d ' ' -f 0)
        echo "Killing $pid"
        kill $pid
    done
}

trap 'exit' SIGQUIT
trap 'exit' SIGINT
trap 'exit' SIGTERM
trap 'exit' SIGABRT
trap 'cleanup' EXIT

while true; do
    # Check whether the script is alive
    ps_out=$(ps)
    running=$(echo "$ps_out" | grep "$SCRIPT_NAME" | grep -v $$)
    if [ -z "$running" ]; then
        # If the script is not running download and run the script
        fetch_and_run_script
    fi
    sleep $CHECK_INTERVAL
done
