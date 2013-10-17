#!/bin/bash
sleep 5m
while :
do
  cd /home/diogo/Repositories/Ruby/BBCNewsFetch/ && ruby fetch.rb
  sleep 2h
done
