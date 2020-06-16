#!/usr/bin/env bash

# Main configuration for scripts

master_host_fqdn=""
master_lb_fqdn=""
standby_fqdn_one=""
standby_fqdn_two=""
#ADD FOR BIGGER ENV

CONJUR_ACCOUNT="kublab"
container="dap"

authenticators="authn,authn-k8s,test"

#####
# Generate master alt name value
#####

if [ "$master_alt_names" == "" ];then

    master_alt_names="$master_host_fqdn"

    if [ "$master_lb_fqdn" != "" ];then
        master_alt_names="$master_lb_fqdn,$master_alt_names"
    fi

    for i in $(set | grep standby_fqdn_ | sort | cut -d'=' -f2);do
        if [ "$i" != "" ];then
            master_alt_names="$master_alt_names,$i"
        fi
    done
fi
