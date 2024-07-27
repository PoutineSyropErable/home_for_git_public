#!/bin/bash

# Sending custom signal 1 to process named slideshow.sh
pkill -SIGRTMIN+5 slideshow.sh
