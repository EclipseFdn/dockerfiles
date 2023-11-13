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

build_arg planet-venus debian-10-slim "" latest
build_arg planet-venus debian-12-slim "--build-arg DEBIAN_VERSION=12-slim"

build kubectl okd-c1 latest

build_arg hugo-node h0.76.5-n12.22.1 "--build-arg HUGO_VERSION=0.76.5 --build-arg HUGO_FILENAME=hugo_0.76.5_Linux-64bit.deb --build-arg NODE_VERSION=v12.22.1" latest
build_arg hugo-node h0.99.1-n16.15.0 "--build-arg HUGO_VERSION=0.99.1 --build-arg HUGO_FILENAME=hugo_0.99.1_Linux-64bit.deb --build-arg NODE_VERSION=v16.15.0"
build_arg hugo-node h0.110.0-n18.13.0 "--build-arg HUGO_VERSION=0.110.0 --build-arg NODE_VERSION=v18.13.0"
build_arg hugo-node h0.120.4-n18.18.2 "--build-arg DEBIAN_VERSION=12-slim --build-arg HUGO_VERSION=0.120.4 --build-arg NODE_VERSION=v18.18.2"

build_arg drupal-node d9.5.10-n18.18.2 "--build-arg DRUPAL_VERSION=9.5.10 --build-arg NODE_VERSION=v18.18.2" latest

build stack-build-agent h79.1-n12.22.1-jdk11 latest
build_arg stack-build-agent h111.3-n18.18-jdk17 "--build-arg JDK_VERSION=17"
#node version in tag is wrong
build_arg stack-build-agent h111.3-n18.17-jdk11
build_arg stack-build-agent h111.3-n18.17-jdk17 "--build-arg JDK_VERSION=17"

build_arg java-api-base j11-openjdk "--build-arg JDK_VERSION=11:1.16-3" latest
build_arg java-api-base j17-openjdk "--build-arg JDK_VERSION=17:1.16-3"

build_arg containertools alpine-latest "" latest
