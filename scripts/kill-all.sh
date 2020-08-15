#!/bin/bash

pkill -KILL node
pkill -KILL mongod
pkill -KILL screen
screen -wipe >/dev/null 2>/dev/null
