#!/bin/bash

if false; then
    sudo cpu_up          # all cores on
    sudo cpu_smt_on      # SMT or HT on
    sudo cpu_performance # set high clock speed scaling
    sudo gpu_performance # fans at 100%

    ./Liftoff.x86_64 -force-vulkan $@ > out 2>&1 & # start Liftoff
    PID=$! # liftoff's main pid
    kitty /usr/bin/htop -p $PID & # htop and sensors

    wait $PID # wait for liftoff to finish
    sudo cpu_default # set clock scaling back to default
    sudo gpu_default # fans back to default
    exit 0           # exit
fi

sudo cpu_smt_off # turn off SMT or HY cuts logical cores in 1/2
sudo cpu_down    # turn off all but one core, only one core remains

taskset -a -c 0 ./Liftoff.x86_64 -force-vulkan $@ & # start Liftoff
PID=$! # liftoff's main pid

sleep 30             # wait 30s

sudo cpu_up          # power up all cores
sudo cpu_smt_on      # enable SMT or HT
sudo cpu_performance # set high clock speed scaling
sudo gpu_performance # gpu fan at 100%
sudo cpu_game_up
taskset -a -p -c 0-2 $PID # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 3 $PID # move the main lift off task to core 1 the rest stay on core 0

taskset -p -c 4 $(ls -1 /proc/$PID/task/  | sed -n '8p')  # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 5 $(ls -1 /proc/$PID/task/  | sed -n '28p') # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 6 $(ls -1 /proc/$PID/task/  | sed -n '29p') # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 7 $(ls -1 /proc/$PID/task/  | sed -n '30p') # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 8 $(ls -1 /proc/$PID/task/  | sed -n '42p') # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 9 $(ls -1 /proc/$PID/task/  | sed -n '44p') # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 10 $(ls -1 /proc/$PID/task/  | sed -n '45p') # move the main lift off task to core 1 the rest stay on core 0

#kitty bash -c "kitty @ new-window gdb --pid $BPID &\
#    kitty @ launch --location vsplit watch -t -n0.5 sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info &\
#    kitty @ launch --location vsplit sudo radeontop &\
#    /usr/local/bin/htop -p $PID" # htop and start a debugging window
kitty /usr/bin/htop -p $PID & # htop and sensors

wait $PID # wait for liftoff to finish
sudo cpu_game_down
sudo cpu_default # normal clock scaling
sudo gpu_default # normal fan speeds
