#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <tag> <version>"
  exit 1
fi

# tag must be either "squads" or "fut-squads"
if [ "$1" != "squads" ] && [ "$1" != "fut-squads" ]; then
  echo "Invalid tag. Please use 'squads' or 'fut-squads'."
  exit 1
fi

# version must be a number
if ! [[ "$2" =~ ^[0-9]+$ ]]; then
  echo "Invalid version. Please provide a number."
  exit 1
fi

# Check if gh (GitHub CLI) is installed
if ! command -v gh &> /dev/null; then
  echo "gh (GitHub CLI) could not be found. Please install it from https://github.com/cli/cli."
  exit 1
fi

TAG=$1
VERSION=$2
RELEASE_EXISTS=$(if gh release view "${TAG}-${VERSION}"; then echo 0; else echo 1; fi)

# Create the release if it doesn't exist
if [ -n "$RELEASE_EXISTS" ]; then
    echo "Creating release... (TAG: $TAG | VERSION: $VERSION)"
    gh release create "${TAG}-${VERSION}" "${TAG}.zip" -t "${TAG} v${VERSION}" -n "Downloaded ${TAG} for VERSION ${VERSION}."
else
    echo "Release ${TAG}-${VERSION} already exists. Skipping creation."
fi
