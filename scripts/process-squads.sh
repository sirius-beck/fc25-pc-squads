#!/bin/bash

RESULT_FOLDER="downloader/result/pc64"

if [ ! -d "$RESULT_FOLDER" ]; then
  echo "Result folder not found: $RESULT_FOLDER"
  exit 1
fi

if ! [ -d version ]; then
  mkdir version
fi

# Process FUT folder
FUT_SQUADS_FOLDER=$(ls -d $RESULT_FOLDER/FUT/*/)
FUT_SQUADS_VERSION=$(basename "$FUT_SQUADS_FOLDER")
FUT_SQUADS_FILES=$(find "$FUT_SQUADS_FOLDER" -type f ! -name "*.bin")
zip -j fut-squads.zip "$FUT_SQUADS_FILES"
echo "FUT_SQUADS_VERSION=$FUT_SQUADS_VERSION" >> "$GITHUB_ENV"
echo "$FUT_SQUADS_VERSION" > version/fut-squads.version

# Process squads folder
SQUADS_FOLDER=$(ls -d $RESULT_FOLDER/squads/*/)
SQUADS_VERSION=$(basename "$SQUADS_FOLDER")
SQUADS_FILES=$(find "$SQUADS_FOLDER" -type f ! -name "*.bin")
zip -j squads.zip "$SQUADS_FILES"
echo "SQUADS_VERSION=$SQUADS_VERSION" >> "$GITHUB_ENV"
echo "$SQUADS_VERSION" > version/squads.version
