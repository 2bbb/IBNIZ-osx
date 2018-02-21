#!/bin/bash

git submodule update --init --recursive

SRC_DIR=IBNIZ/src
SDL_VERSION=1.2.15

if [ -f $SRC_DIR/SDLMain.h -a -f $SRC_DIR/SDLMain.m -a -d /Library/Frameworks/SDL.framework ]; then
	echo exist SDL
else
	if [ ! -d data ]; then
		mkdir data
	fi

	if [ ! -f data/SDL-$SDL_VERSION.dmg ]; then
		echo "download SDL-$SDL_VERSION.dmg to data/SDL-$SDL_VERSION.dmg"
		wget --no-check-certificate https://www.libsdl.org/release/SDL-$SDL_VERSION.dmg -O data/SDL-$SDL_VERSION.dmg
	fi

	DMG_PATH=`pwd`/data/SDL-$SDL_VERSION.dmg
	echo "mount $DMG_PATH"
	hdiutil mount $DMG_PATH

	if [ ! -d /Library/Frameworks/SDL.framework ]; then
		echo "copy SDL.framework to /Library/Frameworks/SDL.framework"
		sudo cp -R /Volumes/SDL/SDL.framework /Library/Frameworks/SDL.framework
	fi

	if [ ! -f $SRC_DIR/SDLMain.h ]; then
		echo "copy SDLMain.h to $SRC_DIR/SDLMain.h"
		cp /Volumes/SDL/devel-lite/SDLMain.h $SRC_DIR/SDLMain.h
	fi

	if [ ! -f $SRC_DIR/SDLMain.m ]; then
		echo "copy SDLMain.m to $SRC_DIR/SDLMain.m"
		cp /Volumes/SDL/devel-lite/SDLMain.m $SRC_DIR/SDLMain.m
	fi

	umount /Volumes/SDL
fi

cd $SRC_DIR
make -f ../../Makefile