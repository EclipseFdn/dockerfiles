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
REPO_NAME="${REPO_NAME:-eclipsefdn}"
DOCKERTOOLS_PATH="${DOCKERTOOLS_PATH:-"${SCRIPT_FOLDER}/.dockertools"}"

build() {
  local push="false"
  if [[ "${BRANCH_NAME:-none}" = "master" ]]; then
    push="true"
  fi

  local images="${REPO_NAME}/${1}:${2}"
  if [[ "${3:-}" = "latest" ]]; then
    images="${images},${REPO_NAME}/${1}:latest"
  fi

  "${DOCKERTOOLS_PATH}/dockerw" build2 "${images}" "${1}/${2}/Dockerfile" "${1}/${2}" "${push}"
}

if [[ -d "${DOCKERTOOLS_PATH}" ]]; then
  git -C "${DOCKERTOOLS_PATH}" fetch -f --no-tags --progress --depth 1 https://github.com/eclipse-cbi/dockertools.git +refs/heads/master:refs/remotes/origin/master
  git -C "${DOCKERTOOLS_PATH}" checkout -f "$(git -C "${DOCKERTOOLS_PATH}" rev-parse refs/remotes/origin/master)"
else 
  git init "${DOCKERTOOLS_PATH}"
  git -C "${DOCKERTOOLS_PATH}" fetch --no-tags --progress --depth 1 https://github.com/eclipse-cbi/dockertools.git +refs/heads/master:refs/remotes/origin/master
  git -C "${DOCKERTOOLS_PATH}" config remote.origin.url https://github.com/eclipse-cbi/dockertools.git
  git -C "${DOCKERTOOLS_PATH}" config --add remote.origin.fetch +refs/heads/master:refs/remotes/origin/master
  git -C "${DOCKERTOOLS_PATH}" config core.sparsecheckout true
  git -C "${DOCKERTOOLS_PATH}" config advice.detachedHead false
  git -C "${DOCKERTOOLS_PATH}" checkout -f "$(git -C "${DOCKERTOOLS_PATH}" rev-parse refs/remotes/origin/master)"
fi