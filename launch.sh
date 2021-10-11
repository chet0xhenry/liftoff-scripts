#!/bin/bash
./screen_play #setup the screen for play

sudo cpu_smt_off # turn off SMT or HY cuts logical cores in 1/2
sudo cpu_down 6  # turn off all but n cores

taskset -a -c 0 ./Liftoff.x86_64 -force-vulkan -job-worker-count 5 -monitor 3 -force-wayland -no-stereo-rendering -screen-fullscreen 1 -screen-quality Fantastic -screen-height 720 -screen-width 1280 -nolog $@ & # start Liftoff
#taskset -a -c 0 ./Liftoff.x86_64 -force-vulkan -job-worker-count 5 -monitor 3 -force-wayland -no-stereo-rendering -screen-fullscreen 1 -screen-quality Fantastic -screen-height 720 -screen-width 1280 -nolog -force-wayland -force-gfx-direct $@ & # start Liftoff
PID=$! # liftoff's main pid

sleep 30             # wait 30s

sudo cpu_up          # power up all cores
sudo cpu_smt_on      # enable SMT or HT
sudo cpu_performance # set high clock speed scaling
sudo gpu_performance # gpu fan at 100%
sudo cpu_game_up
taskset -a -p -c 0-2 $PID # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 3 $PID # move the main lift off task to core 1 the rest stay on core 0

taskset -p -c 4 $(ls -1 /proc/$PID/task/  | sed -n '8p')
taskset -p -c 5 $(ls -1 /proc/$PID/task/  | sed -n '9p')
taskset -p -c 6 $(ls -1 /proc/$PID/task/  | sed -n '10p')
taskset -p -c 7 $(ls -1 /proc/$PID/task/  | sed -n '11p')
taskset -p -c 8 $(ls -1 /proc/$PID/task/  | sed -n '12p')

taskset -p -c 9  $(ls -1 /proc/$PID/task/  | sed -n '32p')
taskset -p -c 10 $(ls -1 /proc/$PID/task/  | sed -n '33p')
taskset -p -c 11 $(ls -1 /proc/$PID/task/  | sed -n '34p')
taskset -p -c 12 $(ls -1 /proc/$PID/task/  | sed -n '35p')

kitty /usr/bin/htop -p $PID & # htop and sensors
sleep 1
./mvwin htop HDMI-A-0

wait $PID # wait for liftoff to finish
sudo cpu_game_down
sudo cpu_default # normal clock scaling
sudo gpu_default # normal fan speeds
./screen_work
