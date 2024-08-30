#!/bin/bash
source ./etc/utils.sh

download_app() {
    app_name=$1

    # Attempt to download from APKMirror
    if apkmirror "$app_name"; then
        echo "Download successful from APKMirror for $app_name."
        return 0
    fi

    # If APKMirror fails, attempt to download from Uptodown
    echo "APKMIRROR download failed, trying Uptodown for $app_name..."
    if uptodown "$app_name"; then
        echo "Download successful from Uptodown for $app_name."
        return 0
    fi

    # If Uptodown fails, attempt to download from APKPure
    echo "Uptodown download failed, trying APKPure for $app_name..."
    if apkpure "$app_name"; then
        echo "Download successful from APKPure for $app_name."
        return 0
    fi

    # If all sources fail
    echo "All download attempts failed for $app_name."
    return 1
}

# Main script 
patch_upload() {
    app_name=$1
    download_app "$app_name"
    apply_patches "$app_name"
    sign_patched_apk "$app_name"
    create_github_release "$app_name"
}

# Perform download_repository_assets
download_resources

ls revanced-patches*.jar > current_file.txt

if diff -q current_file.txt patches.txt > /dev/null; then
    echo "No change, skipping patch..."
else
    rm patches.txt > /dev/null 2>&1
    # Patch YouTube
    patch_upload "youtube"

    # Patch YouTube Music 
    patch_upload "youtube-music"
    mv current_file.txt patches.txt
fi
