#!/bin/bash

update_grub_configuration() {
    # Backup the original GRUB configuration file
    sudo cp /etc/default/grub /etc/default/grub.bak

    # Append the desired kernel parameter to the GRUB_CMDLINE_LINUX variable without a space in front
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1tsc=reliable clocksource=tsc"/' /etc/default/grub

    # Update the GRUB bootloader
    sudo update-grub
}

configure_systemwide_dri() {
    # Set the systemwide configuration content
    systemwide_config='<driconf>
       <device>
           <application name="Default">
               <option name="vblank_mode" value="0" />
           </application>
       </device>
    </driconf>'
    
    # Create or update /etc/drirc with the systemwide configuration content
    sudo sh -c "echo \"$systemwide_config\" > /etc/drirc"
}

# Function to configure kernel parameters using systemd-tmpfiles
configure_kernel_parameters() {
    # Create the configuration file
    echo -e "#    Path                  Mode UID  GID  Age Argument
w /proc/sys/vm/compaction_proactiveness - - - - 0
w /proc/sys/vm/min_free_kbytes - - - - 1048576
w /proc/sys/vm/swappiness - - - - 10
w /sys/kernel/mm/lru_gen/enabled - - - - 5
w /proc/sys/vm/zone_reclaim_mode - - - - 0
w /sys/kernel/mm/transparent_hugepage/enabled - - - - never
w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - never
w /sys/kernel/mm/transparent_hugepage/khugepaged/defrag - - - - 0
w /proc/sys/vm/page_lock_unfairness - - - - 1
w /proc/sys/kernel/sched_child_runs_first - - - - 0
w /proc/sys/kernel/sched_autogroup_enabled - - - - 1
w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 500
w /sys/kernel/debug/sched/latency_ns  - - - - 1000000
w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000
w /sys/kernel/debug/sched/min_granularity_ns - - - - 500000
w /sys/kernel/debug/sched/wakeup_granularity_ns  - - - - 0
w /sys/kernel/debug/sched/nr_migrate - - - - 8" | sudo tee /etc/tmpfiles.d/consistent-response-time-for-gaming.conf > /dev/null
}

# Function to set LD_BIND_NOW environment variable for games
set_ld_bind_now() {
    # Check if the variable is already set in the configuration file
    if grep -q "LD_BIND_NOW=1" "$HOME/.bashrc"; then
        echo "LD_BIND_NOW is already set in the configuration file."
    else
        # Add the LD_BIND_NOW environment variable to the configuration file
        echo "export LD_BIND_NOW=1" >> "$HOME/.bashrc"
        echo "LD_BIND_NOW set in the configuration file."
    fi
}

# Call the functions
update_grub_configuration
configure_systemwide_dri
configure_kernel_parameters
set_ld_bind_now



