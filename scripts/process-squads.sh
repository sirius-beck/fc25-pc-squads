#!/bin/bash

md release-files

# Process FUT folder
fut_folder=$(ls -d downloader/result/pc64/FUT/*/)
fut_version=$(basename "$fut_folder")
fut_files=$(find "$fut_folder" -type f ! -name "*.bin")
zip -j release-files/fut-squads.zip $fut_files

# Process squads folder
squads_folder=$(ls -d downloader/result/pc64/squads/*/)
squads_version=$(basename "$squads_folder")
squads_files=$(find "$squads_folder" -type f ! -name "*.bin")
zip -j release-files/squads.zip $squads_files
