#! /usr/bin/env bash
#*****************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*****************************************************************************

# Bash strict-mode
set -o errexit
set -o nounset
set -o pipefail

SCRIPT_FOLDER="$(dirname "$(readlink -f "${0}")")"

. "${SCRIPT_FOLDER}/build_init.sh"

build nginx stable-alpine latest
build nginx stable-alpine-for-hugo latest
build nginx stable-alpine-for-staging

build planet-venus debian-10-slim latest

build kubectl 1.9-alpine 
build kubectl 1.14-alpine
build kubectl 1.18-alpine latest
build kubectl okd-c1

build hugo-node h0.62.2-n10.15.0 
build hugo-node h0.76.5-n12.22.1 latest

build stack-build-agent h79.1-n12.22.1-jdk11 latest
