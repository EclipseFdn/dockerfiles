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
  "${DOCKERTOOLS_PATH}/dockerw" build_and_push "${REPO_NAME}/${1}" "${2}" "${1}/${2}/Dockerfile"
  if [[ "${3:-}" = "latest" ]]; then
    tag_latest "${1}" "${2}"
  fi
}

tag_latest() {
  local f=$1
  local t=$2
  "${DOCKERTOOLS_PATH}/dockerw" tag_alias "${REPO_NAME}/${f}" "${t}" "latest"
  "${DOCKERTOOLS_PATH}/dockerw" push_if_changed "${REPO_NAME}/${f}" "latest" "${1}/${2}/Dockerfile"
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