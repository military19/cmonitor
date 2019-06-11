#!/bin/bash

# TODO: add some simulator for network activity!

set -e
set -u

# Constants
num_cycles=50

# Check utility "stress" is available
if [ -z "$(command -v stress)" ]; then
    echo "The 'stress' utility is not present. Cannot continue."
    exit 2
fi

sleep1_sec=$(( $RANDOM % 4 + 1 ))
sleep2_sec=$(( $RANDOM % 8 + 1 ))
sleep3_sec=$(( $RANDOM % 3 + 1 ))

enable_cpu_stress=true
enable_memory_stress=true
enable_disk_stress=true

cycle=1
while (( cycle<num_cycles )); do
    NJPID="$(pidof cmonitor_collector)"
    echo "cmonitor_collector pid=$NJPID; running CPU/memory/disk load simulator cycle #$cycle..."
    if $enable_cpu_stress; then
        if $enable_memory_stress; then
            stress --cpu 1 --vm 1 --timeout $(( $RANDOM % 10 + 1 )) &
            sleep $sleep1_sec
        fi
    fi
    if $enable_cpu_stress; then
        stress --cpu 1 --timeout $(( $RANDOM % 5 + 1 )) &
        sleep $sleep2_sec
    fi
    if $enable_disk_stress; then
        stress --hdd 2 --timeout $(( $RANDOM % 3 + 1 )) &
        sleep $sleep3_sec
    fi

    wait  # each cycle will last about 10secs
    (( cycle++ ))
done

echo "Stopping cmonitor_collector"
pkill cmonitor_collector
sleep 1

echo "Exiting the example-load.sh script..."
