#!/usr/bin/env bash

# On macOS, need to set extra flags instead of running `dub build` directly:
#
# https://forum.dlang.org/post/gcxnzxqxxqeasdkhpqjt@forum.dlang.org

export MACOSX_DEPLOYMENT_TARGET=11
exec dub build --combined --build-mode=allAtOnce
