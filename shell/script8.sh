#!/bin/bash
echo "Line count"
sudo free > /tmp/free.out && \
wc -l < /tmp/free.out 
