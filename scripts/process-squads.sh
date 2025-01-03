#!/bin/bash

SQUADS_UPDATED=true
RESULT_FOLDER="downloader/result/pc64"

if [ ! -d "$RESULT_FOLDER" ]; then
	echo "Result folder not found: $RESULT_FOLDER"
	exit 1
fi

if ! [ -d version ]; then
	mkdir version
fi

function push_version_changes() {
	local version_file="$1"
	local type="$2"
	local version="$3"

	# Check if the version file exists
	if ! [ -f "$version_file" ]; then
		echo "Version file not found: $version_file"
		exit 1
	fi

	# type must be fut-squads or squads
	if [ "$type" != "fut-squads" ] && [ "$type" != "squads" ]; then
		echo "Invalid type. Please use 'fut-squads' or 'squads'."
		exit 1
	fi

	# version must be a number
	if ! [[ "$version" =~ ^[0-9]+$ ]]; then
		echo "Version must be a number."
		exit 1
	fi

	git config --global user.email "siriusbeck.mods@gmail.com"
	git config --global user.name "Sirius Beck"
	git add "$version_file"
	git commit -m "Update ${type} version to ${version}."
	git push
}

function processSquads() {
	local type="$1" # fut-squads | squads
	local folder_name folder files version_data new_version old_version date_utc

	# type must be fut-squads or squads
	if [ "$type" != "fut-squads" ] && [ "$type" != "squads" ]; then
		echo "Invalid type. Please use 'fut-squads' or 'squads'."
		exit 1
	fi

	folder_name=$(if [ "$type" == "fut-squads" ]; then echo "FUT"; else echo "squads"; fi)
	folder=$(ls -d $RESULT_FOLDER/"$folder_name"/*/)
	files=$(find "$folder" -type f ! -name "*.bin")

	version_file="version/${type}.version"
	version_data=$(cat "$version_file" 2> /dev/null)
	new_version=$(basename "$folder")

	IFS='|' read -r old_version _ <<< "$version_data"

	if [ "$new_version" != "$old_version" ]; then
		SQUADS_UPDATED=false
		date_utc=$(date -u +"%m/%d/%Y %H:%M:%S")

		echo "${new_version}|${date_utc}" > "$version_file"
		zip -j "${type}.zip" "$files"

		push_version_changes "$version_file" "$type" "$new_version"

		echo "Updated ${type} version from ${old_version} to ${new_version}."
	fi
}

processSquads "squads"
processSquads "fut-squads"

echo "SQUADS_UPDATED=${SQUADS_UPDATED}" >> "$GITHUB_ENV"
