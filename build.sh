#! /usr/bin/env bash
#*******************************************************************************
# The MIT License (MIT)
#
# Copyright (c) 2017 Jessie Frazelle
# https://github.com/jessfraz/dockerfiles/blob/8bf7bc9f2517176be1783dc55fffb0315df1b508/build-all.sh
#*******************************************************************************

# Bash strict-mode
set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

SCRIPT_FOLDER="$(dirname $(readlink -f "${BASH_SOURCE[0]}"))"

SCRIPT="${SCRIPT_FOLDER}/$(basename "${BASH_SOURCE[0]}")"
REPO_NAME="${REPO_NAME:-eclipsefdn}"
JOBS=${JOBS:-2}

ERRORS="$(pwd)/errors"

push() {
	# try push a few times because notary server sometimes returns 401 for
	# absolutely no reason
	n=0
	until [ $n -ge 5 ]; do
		docker push "$@" && break
		echo "Try #$n failed... sleeping for 15 seconds"
		n=$((n+1))
		sleep 15
	done
}

build_and_push() {
	imageName=$1
	tag=$2
	build_dir=$3

	echo "Building ${REPO_NAME}/${imageName}:${tag} for context ${build_dir}"
	docker build --rm --force-rm -t "${REPO_NAME}/${imageName}:${tag}" "${build_dir}" || return 1

	# on successful build, push the image
	echo "                       ---                                   "
	echo "Successfully built ${REPO_NAME}/${imageName}:${tag} with context ${build_dir}"
	echo "                       ---                                   "

	
	push "${REPO_NAME}/${imageName}:${tag}"

	# also push the tag latest for all tags starting with "stable"
	if [[ "${tag}" =~ stable ]]; then
		docker tag "${REPO_NAME}/${imageName}:${tag}" "${REPO_NAME}/${imageName}:latest"
		push "${REPO_NAME}/${imageName}:latest"
	fi
}

dofile() {
	f=$1
	image=${f%Dockerfile}
	imageName=${image%%\/*}
	build_dir=$(dirname "$f")
	tag=${build_dir##*\/}

	if [[ -z "${tag}" ]] || [[ "${tag}" == "${imageName}" ]]; then
		tag=latest
	fi

	{
		$SCRIPT build_and_push "${imageName}" "${tag}" "${build_dir}"
	} || {
	# add to errors
	echo "${REPO_NAME}/${imageName}:${tag}" >> "${ERRORS}"
}
echo
echo
}

main(){
	# get the dockerfiles
	mapfile -t files < <(find -L . -iname '*Dockerfile' | sed 's|./||' | sort)

	# build all dockerfiles
	echo "Running in parallel with ${JOBS} jobs."
	parallel --tag --verbose --ungroup -j"${JOBS}" "$SCRIPT" dofile "{1}" ::: "${files[@]}"

	if [[ ! -f "${ERRORS}" ]]; then
		echo "No errors, hooray!"
	else
		echo "[ERROR] Some images did not build correctly, see below." >&2
		echo "These images failed:" >&2
		cat "${ERRORS}" >&2
		exit 1
	fi
}

run(){
	args=$*
	f="${1:-}"

	if [[ "${f}" == "" ]]; then
		main "${args}"
	else
		$args
	fi
}

run "${@}"