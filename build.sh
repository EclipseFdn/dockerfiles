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

build kubectl okd-c1 latest

build_arg hugo-node h0.99.1-n16.15.0 "--build-arg HUGO_VERSION=0.99.1 --build-arg HUGO_FILENAME=hugo_0.99.1_Linux-64bit.deb --build-arg NODE_VERSION=v16.15.0"
build_arg hugo-node h0.110.0-n18.19.1 "--build-arg HUGO_VERSION=0.110.0 --build-arg NODE_VERSION=v18.19.1" latest
build_arg hugo-node h0.120.4-n18.19.1 "--build-arg DEBIAN_VERSION=12-slim --build-arg HUGO_VERSION=0.120.4 --build-arg NODE_VERSION=v18.19.1"
build_arg hugo-node h0.124.1-n20.11.1 "--build-arg DEBIAN_VERSION=12-slim --build-arg HUGO_VERSION=0.124.1 --build-arg NODE_VERSION=v20.11.1"
build_arg hugo-node h0.144.2-n22.14.0 "--build-arg DEBIAN_VERSION=12-slim --build-arg HUGO_VERSION=0.144.2 --build-arg NODE_VERSION=v22.14.0"

build_arg drupal-node d10.2.2-n18.19.0 "--build-arg DRUPAL_VERSION=10.2.2 --build-arg NODE_VERSION=v18.19.0"
build_arg drupal-node d10.3.13-n22.14.0 "--build-arg DRUPAL_VERSION=10.3.13 --build-arg NODE_VERSION=v22.14.0" latest
build_arg drupal-node d11.1.3-n22.14.0 "--build-arg DRUPAL_VERSION=11.1.3 --build-arg NODE_VERSION=v22.14.0"


#node version in tag is wrong
build_arg stack-build-agent h111.3-n18.17-jdk11 latest
build_arg stack-build-agent h111.3-n18.17-jdk17 "--build-arg JDK_VERSION=17"
build_arg stack-build-agent a3.19-h120-n20-jdk17 "--build-arg ALPINE_VERSION=3.19 --build-arg JDK_VERSION=17 --build-arg NODE_VERSION=20.15.1-r0 --build-arg NPM_VERSION=10.2.5-r0 --build-arg HUGO_VERSION=0.120.4-r3 --build-arg YARN_VERSION=1.22.19-r0"

## Used for native builds
build_arg native-build-agent m23-n18.20.2 latest

build_arg java-api-base j11-openjdk "--build-arg JDK_VERSION=11:1.17" latest
build_arg java-api-base j17-openjdk "--build-arg JDK_VERSION=17:1.17"

build_arg containertools alpine-latest "" latest
