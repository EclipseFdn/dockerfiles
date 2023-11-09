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
  docker build --pull -t "${REPO_NAME}/${1}:${2}" -f "${1}/${2}/Dockerfile" "${1}/${2}"

  if [[ "${BRANCH_NAME:-none}" == "master" ]]; then
    docker push "${REPO_NAME}/${1}:${2}"
    if [[ "${3:-}" == "latest" ]]; then
      docker tag "${REPO_NAME}/${1}:${2}" "${REPO_NAME}/${1}:latest"
      docker push "${REPO_NAME}/${1}:latest"
    fi
  fi

}

build_arg() {
  local image_name="${1:-}" # image_name == folder name
  local tag="${2:-}"
  local args="${3:-}" # must be set as empty parameter if latest is set
  local latest="${4:-}"
  if [[ -z "${args}" ]]; then
    docker build --pull -t "${REPO_NAME}/${image_name}:${tag}" -f "${image_name}/Dockerfile" "${image_name}"
  else
    docker build --pull -t "${REPO_NAME}/${image_name}:${tag}" -f "${image_name}/Dockerfile" ${args} "${image_name}" #args should not be surrounded by quotes
  fi

  if [[ "${BRANCH_NAME:-none}" == "master" ]]; then
    docker push "${REPO_NAME}/${image_name}:${tag}"
    if [[ "${latest}" == "latest" ]]; then
      docker tag "${REPO_NAME}/${image_name}:${tag}" "${REPO_NAME}/${image_name}:latest"
      docker push "${REPO_NAME}/${image_name}:latest"
    fi
  fi
}