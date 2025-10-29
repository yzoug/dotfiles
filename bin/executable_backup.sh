#!/usr/bin/env bash
# Script to backup my files using an external SSD harddrive, which has a
# LUKS encrypted partition, which contains a password-protected Restic
# backup
#
# zoug
#

# Enable xtrace if the DEBUG environment variable is set
if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace       # Trace the execution of the script (debug)
fi

# Only enable these shell behaviours if we're not being sourced
# Approach via: https://stackoverflow.com/a/28776166/8787985
if ! (return 0 2> /dev/null); then
    # A better class of script...
    set -o errexit      # Exit on most errors (see the manual)
    set -o nounset      # Disallow expansion of unset variables
    set -o pipefail     # Use last non-zero exit code in a pipeline
fi

function mount_t7 {
    local disk_path
    disk_path=$(lsblk -po NAME,MODEL | grep "PSSD T7" | cut -d ' ' -f 1)
    if [[ $? -eq 0 && ${disk_path} =~ ^/dev/sd.$ ]]; then
        log "Unlocking LUKS ${disk_path}4 partition..."
        sudo cryptsetup open "${disk_path}4" planque
        log "Mounting SSD in /dev/mapper/planque to /mnt/usb..."
        sudo mount /dev/mapper/planque /mnt/planque
    else
        log "T7 probably not connected, or weird disk path"
        return 1
    fi
}

function umount_t7 {
    log "Unmounting the T7 LUKS partition..."
    sudo umount /mnt/planque
    sudo sync
    log "Closing the LUKS parition..."
    sudo cryptsetup close /dev/mapper/planque
}

function backup {
    echo
    log "Launching backup..."
    sudo restic -r /mnt/planque/restic-ssd-t7 backup ~/Divers ~/Musique ~/Photos ~/shots ~/tools ~/work ~/.ssh -e ~/Divers/Films -e ~/Divers/nostalgia/Entrainement
}

function log {
    echo "$(date --rfc-3339 s) ${1}"
}

if mount_t7; then
    backup
    umount_t7
fi
