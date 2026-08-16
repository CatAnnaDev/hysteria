#!/bin/bash
cd "$(dirname "$0")"
INST=2 RES="${RES:-1280x720}" BOTTLE_NAME="${BOTTLE_NAME:-Steam}" bash play.command
