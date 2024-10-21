#!/bin/bash
source ./etc/utils.sh

download_app() {
    app_name=$1
    sources=("apkmirror" "uptodown" "apkpure")

    for source in "${sources[@]}"; do
        if $source "$app_name"; then
            return 0
        fi
    done
    
    return 1
}

# Main script 
patch_upload() {
    app_name=$1
    download_app "$app_name"
    apply_patches "$app_name"
    create_github_release "$app_name"
}

# Function to compare versions of two repositories
compare_repository_versions() {    
    version_patches=$(get_latest_release_version "ReVanced/revanced-patches")
    version_current=$(get_latest_release_version "$GITHUB_REPOSITORY")

    if [[ -n "$version_patches" && -n "$version_current" ]]; then
        if [[ "$version_patches" == "$version_current" ]]; then
            echo "Patched! Skipping build..."
            return 0  # Skip build if versions are the same
        else
            return 1  # Run build if versions differ
        fi
    else
        return 1  # Run build if either repository fails to respond
    fi
}

# Compare versions
if ! compare_repository_versions "$repo_patches" "$repository"; then
    echo "Running build..."
    download_resources
    patch_upload "youtube"
    patch_upload "youtube-music"
fi
