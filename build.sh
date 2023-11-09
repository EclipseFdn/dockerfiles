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

# build_arg <image_name> <tag> [build-args] [latest]

build nginx stable-alpine latest
build nginx stable-alpine-for-staging

build planet-venus debian-10-slim latest

build kubectl okd-c1 latest

build hugo-node h0.62.2-n10.15.0
build hugo-node h0.99.1-n16.15.0
build hugo-node h0.110.0-n18.13.0
build hugo-node h0.76.5-n12.22.1 latest

build_arg drupal-node d9.5.10-n18.18.2 "--build-arg DRUPAL_VERSION=9.5.10 --build-arg NODE_VERSION=v18.18.2" latest

build stack-build-agent h79.1-n12.22.1-jdk11 latest
build stack-build-agent h111.3-n18.17-jdk11
build stack-build-agent h111.3-n18.17-jdk17

build_arg java-api-base j11-openjdk "--build-arg JDK_VERSION=11:1.16-3" latest
build_arg java-api-base j17-openjdk "--build-arg JDK_VERSION=17:1.16-3"

build containertools alpine-latest latest