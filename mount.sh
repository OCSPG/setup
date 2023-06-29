#!/bin/bash

# Function to retrieve UID and GID of the user
get_user_info() {
    USER_UID=$(id -u)
    USER_GID=$(id -g)
}

# Function to display available partitions and prompt for selection
select_partitions() {
    echo "Available partitions:"
    partitions=()
    i=1

    # Retrieve partition information and populate the array
    while IFS= read -r line; do
        partition=$(echo "$line" | awk '{print $1}')
        partitions+=("$partition")
        echo "$i. $line"
        ((i++))
    done < <(sudo lsblk -o PATH,FSTYPE,UUID | awk '$1 ~ /^\// {print $1,$2,$3}')

    # Prompt user for partition selection
    read -rp "Enter the numbers of the partitions you want to mount (separated by spaces): " choices

    # Validate and mount selected partitions
    for choice in $choices; do
        if ((choice >= 1 && choice <= i-1)); then
            mount_partition "${partitions[choice-1]}"
        fi
    done
}

# Function to mount the selected partition
mount_partition() {
    partition="$1"
    mount_dir="/mount/$partition"

    # Create the mountpoint directory
    sudo mkdir -p "$mount_dir"

    # Determine the filesystem type of the partition
    filesystem=$(sudo lsblk -no FSTYPE "$partition")

    # Determine if the partition is on an NVMe drive
    nvme_load=""

    if sudo lsblk -no TRAN "$partition" | grep -q "nvme"; then
        nvme_load="nvme_load=yes"
    fi

    # Add an entry to /etc/fstab
    echo "# $partition" | sudo tee -a /etc/fstab
    echo "UUID=$(sudo blkid -s UUID -o value "$partition") $mount_dir $filesystem uid=$USER_UID,gid=$USER_GID,rw,user,exec,umask=000,$nvme_load 0 0" | sudo tee -a /etc/fstab

    echo "Partition $partition mounted at $mount_dir"
}

# Main script execution
echo "Partition Mount Script"
echo

echo "Retrieving user information..."
get_user_info
echo

select_partitions

echo "Mounting completed. Updated /etc/fstab file."
