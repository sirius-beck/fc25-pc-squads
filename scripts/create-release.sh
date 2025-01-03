#!/bin/bash

# Check if gh (GitHub CLI) is installed
if ! command -v gh &> /dev/null; then
	echo "gh (GitHub CLI) could not be found. Please install it from https://github.com/cli/cli."
	exit 1
fi

FUT_SQUADS_VERSION_DATA=$(cat "version/fut-squads.version" 2> /dev/null)
SQUADS_VERSION_DATA=$(cat "version/squads.version" 2> /dev/null)

IFS='|' read -r FUT_SQUADS_VERSION FUT_SQUADS_UPDATED_AT <<< "$FUT_SQUADS_VERSION_DATA"
IFS='|' read -r SQUADS_VERSION SQUADS_UPDATED_AT <<< "$SQUADS_VERSION_DATA"

RELEASE_TAG="squads"
RELEASE_TITLE="FC25 Squads"
RELEASE_NOTES=$(cat << EOF
File | Version | Updated At
--- | --- | ---
Squads | \`${SQUADS_VERSION}\` | \`${FUT_SQUADS_UPDATED_AT}\`
FutSquads | \`${FUT_SQUADS_VERSION}\` | \`${SQUADS_UPDATED_AT}\`
EOF
)
RELEASE_FILES=()
RELEASE_EXISTS=$(if gh release view "$RELEASE_TAG"; then echo true; else echo false; fi)

if [ -f "squads.zip" ]; then
	RELEASE_FILES+=("squads.zip")
fi

if [ -f "fut-squads.zip" ]; then
	RELEASE_FILES+=("fut-squads.zip")
fi

if [ "$SQUADS_UPDATED" == false ]; then
	if [ "$RELEASE_EXISTS" == true ]; then
		echo "Updating release... Tag: ${RELEASE_TAG}"
		gh release edit "$RELEASE_TAG" --title "$RELEASE_TITLE" --notes "$RELEASE_NOTES" --latest
	else
		echo "Creating new release... Tag: ${RELEASE_TAG}"
		gh release create "$RELEASE_TAG" --title "$RELEASE_TITLE" --notes "$RELEASE_NOTES" --latest
	fi

	gh release upload "$RELEASE_TAG" "${RELEASE_FILES[@]}" --clobber
fi
