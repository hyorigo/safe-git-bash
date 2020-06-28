#!/bin/bash

function check_in_git_repo() {
	git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

function check_git_status() {
	local UPSTREAM=${1:-'@{u}'}
	local LOCAL=$(git rev-parse @)
	local REMOTE=$(git rev-parse "$UPSTREAM")
	local BASE=$(git merge-base @ "$UPSTREAM")

	if [ $LOCAL = $REMOTE ]; then
		echo "up-to-date"
	elif [ $LOCAL = $BASE ]; then
		echo "need to pull"
		exit 1
	elif [ $REMOTE = $BASE ]; then
		echo "need to push"
		exit 2
	else
		echo "diverged"
		exit 3
	fi
}

function check_untracked() {
	if ! git diff-index --quiet HEAD --; then
		echo "got untracked changes"
		exit 4
	fi
}

function check_on_branch() {
	local TARGET=master
	local BRANCH=$(git rev-parse --abbrev-ref HEAD)
	if [[ "${BRANCH}" != "${TARGET}" ]]; then
		echo "should be on '${TARGET}' branch"
		exit 5
	fi
}
