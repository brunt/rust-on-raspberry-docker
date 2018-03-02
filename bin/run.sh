#!/bin/bash
set -e;
cd $HOME/project;
$HOME/.cargo/bin/cargo build --target=armv7-unknown-linux-gnueabihf
