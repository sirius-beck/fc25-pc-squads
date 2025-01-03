#!/bin/bash

tag = $1 // "squads" or "fut-squads"
version = $2
release_exists=$(gh release view $tag-$version --json tagName --jq '.tagName' || echo "not_found")

echo "tag: $tag | version: $version"
exit 0

if [ "$release_exists" == "not_found" ]; then
    gh release create $tag-$version $tag.zip -t "$tag v$version" -n "Downloaded $tag for version $version."
else
    echo "Release $tag-$version already exists. Skipping creation."
fi
