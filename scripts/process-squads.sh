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

function processSquads() {
	local type="$1" # fut-squads | squads
	local folder_name folder files version_data new_version old_version date_utc

	if [ "$type" != "fut-squads" ] && [ "$type" != "squads" ]; then
		echo "Invalid type. Please use 'fut-squads' or 'squads'."
		exit 1
	fi

	folder_name=$(if [ "$type" == "fut-squads" ]; then echo "FUT"; else echo "squads"; fi)
	folder=$(ls -d $RESULT_FOLDER/"$folder_name"/*/)
	files=$(find "$folder" -type f ! -name "*.bin")

	version_data=$(cat "version/${type}.version" 2> /dev/null)
	new_version=$(basename "$folder")

	IFS='|' read -r old_version _ <<< "$version_data"

	if [ "$new_version" != "$old_version" ]; then
		SQUADS_UPDATED=false
		date_utc=$(date -u +"%m/%d/%Y %H:%M:%S")

		echo "${new_version}|${date_utc}" > "version/${type}.version"
		zip -j "${type}.zip" "$files"
		echo "Updated ${type} version from ${old_version} to ${new_version}."
	fi
}

processSquads "squads"
processSquads "fut-squads"

echo "SQUADS_UPDATED=${SQUADS_UPDATED}" >> "$GITHUB_ENV"
