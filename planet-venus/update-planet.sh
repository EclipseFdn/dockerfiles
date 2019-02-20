#! /usr/bin/env bash
#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************

set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

PLANET="${1:-}"
WWW="${2:-}"
BRANCH_NAME="${3:-master}"

cd "${PLANET}"
while true; do
  git fetch origin
  git reset --hard origin/${BRANCH_NAME} 
  planet planet.ini
  if [[ -d "theme/css" ]]; then
    cp -rf "theme/css" "${WWW}"
  fi
  if [[ -d "theme/authors" ]]; then 
    cp -rf "theme/authors" "${WWW}"
  fi
  if [[ -d "theme/images" ]]; then 
    cp -rf "theme/images" "${WWW}"
  fi

  sleep 1200
done