#!/bin/bash
#./screen_play #setup the screen for play

#sudo cpu_smt_off # turn off SMT or HY cuts logical cores in 1/2
#sudo cpu_down 6  # turn off all but n cores

taskset -a -c 10,11,22-23 ./Liftoff.x86_64 -force-vulkan -job-worker-count 5 -monitor 1 -force-wayland -no-stereo-rendering -screen-fullscreen 1 -screen-quality Fantastic -screen-height 720 -screen-width 1280 -nolog $@ & # start Liftoff
#taskset -a -c 10,11,22-23 ./Liftoff.x86_64 -force-vulkan -job-worker-count 5 -monitor 2 -force-wayland -no-stereo-rendering -screen-fullscreen 1 -screen-quality Fantastic -screen-height 720 -screen-width 1280 -nolog $@ & # start Liftoff
#taskset -a -c 0 ./Liftoff.x86_64 -force-vulkan -job-worker-count 5 -monitor 3 -force-wayland -no-stereo-rendering -screen-fullscreen 1 -screen-quality Fantastic -screen-height 720 -screen-width 1280 -nolog -force-wayland -force-gfx-direct $@ & # start Liftoff
PID=$! # liftoff's main pid

#kitty /usr/bin/htop -p $PID & # htop and sensors
#sleep 1
#./mvwin htop HDMI-A-0

#sudo cpu_up          # power up all cores
#sudo cpu_smt_on      # enable SMT or HT
sudo cpu_performance # set high clock speed scaling
sudo gpu_performance # gpu fan at 100%
sudo cpu_game_up

sleep 60             # wait 30s
taskset -p -c 0 $PID # move the main lift off task to core 1 the rest stay on core 0
taskset -p -c 1 $(ls -1 /proc/$PID/task/  | sed -n '35p')
taskset -p -c 2 $(ls -1 /proc/$PID/task/  | sed -n '11p')
taskset -p -c 3 $(ls -1 /proc/$PID/task/  | sed -n '12p')
taskset -p -c 4 $(ls -1 /proc/$PID/task/  | sed -n '13p')
taskset -p -c 5 $(ls -1 /proc/$PID/task/  | sed -n '14p')
taskset -p -c 6 $(ls -1 /proc/$PID/task/  | sed -n '15p')
taskset -p -c 7 $(ls -1 /proc/$PID/task/  | sed -n '36p')
taskset -p -c 8 $(ls -1 /proc/$PID/task/  | sed -n '37p')
taskset -p -c 9 $(ls -1 /proc/$PID/task/  | sed -n '38p')

sudo renice -n -20 -p $PID # move the main lift off task to core 1 the rest stay on core 0
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '35p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '11p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '12p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '13p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '14p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '15p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '36p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '37p')
sudo renice -n -20 -p $(ls -1 /proc/$PID/task/  | sed -n '38p')


wait $PID # wait for liftoff to finish
sudo cpu_game_down
sudo cpu_default # normal clock scaling
sudo gpu_default # normal fan speeds
./screen_work
