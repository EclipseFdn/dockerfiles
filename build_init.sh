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

REPO_NAME="${REPO_NAME:-docker.io/eclipsefdn}"

build() {
  local output="type=image"
  local cacheTo=""
  local cacheFrom="--cache-from=type=registry,ref=${REPO_NAME}/${1}:${2}"

  local images="${REPO_NAME}/${1}:${2}"
  if [[ "${3:-}" == "latest" ]]; then
    images="${images},${REPO_NAME}/${1}:latest"
  fi
  output="${output},\"name=${images}\""

  if [[ "${BRANCH_NAME:-none}" = "master" ]]; then
    output="${output},push=true"
    cacheTo="--cache-to=type=registry,ref=${REPO_NAME}/${1}:${2}-buildcache,mode=max"
  else
    output="${output},push=false"
    cacheTo="--cache-to=type=registry,ref=${REPO_NAME}/${1}:${BRANCH_NAME:-none}-buildcache,mode=max"
  fi
  docker buildx build --output="${output}" "${cacheFrom}" "${cacheTo}" -f "${1}/${2}/Dockerfile" "${1}/${2}"
}
