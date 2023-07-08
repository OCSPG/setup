#!/bin/bash

grant_corectrl_access_polkit_newer() {
    # Find the group the user is in
    user_group=$(id -gn)

    # Create the Polkit rule file
    echo -e "polkit.addRule(function(action, subject) {
    if ((action.id == \"org.corectrl.helper.init\" ||
         action.id == \"org.corectrl.helperkiller.init\") &&
        subject.local == true &&
        subject.active == true &&
        subject.isInGroup(\"$user_group\")) {
            return polkit.Result.YES;
    }
});" | sudo tee /etc/polkit-1/rules.d/90-corectrl.rules > /dev/null
}

configure_amdgpu_boot_parameter() {
    # Edit the GRUB configuration file
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amdgpu.ppfeaturemask=0xffffffff"/' /etc/default/grub
    
    # Update the GRUB bootloader
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}