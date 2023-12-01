#!/usr/bin/env bash
###############################################################################
##
##       filename: makefile
##    description:
##        created: 2023/12/01
##         author: ticktechman
##
###############################################################################
.PHONY: all build test install doc

all: hello

hello: bin/dart_study.dart
	@dart compile  exe --target-os=macos $^ -o $@

clean:
	rm -f hello
###############################################################################
