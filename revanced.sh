#!/bin/bash
source ./etc/utils.sh

# Main script 

# Perform download_repository_assets
download_resources

ls revanced-patches*.jar > current_file.txt

if cmp -s current_file.txt patches.txt; then
    echo "No change, skipping patch..."
else
    rm patches.txt > /dev/null 2>&1
    # Patch YouTube
    apkmirror "google-inc" \
              "youtube" \
              "com.google.android.youtube"
    apply_patches "youtube"
    sign_patched_apk "youtube"
    create_github_release "youtube"

    # Patch YouTube Music 
    apkmirror "google-inc" \
              "youtube-music" \
              "com.google.android.apps.youtube.music" \
              "arm64-v8a"
    apply_patches "youtube-music"
    sign_patched_apk "youtube-music"
    create_github_release "youtube-music"
    mv current_file.txt patches.txt
fi
