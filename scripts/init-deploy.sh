#
# The purpose of this script is for an ansibilized or templated build and no cli option is available. This will
# create an admin API account and load some templated policy. Please reference ../001_root-config.yml
#

#!/usr/bin/env bash
master_name=""
dap_name=""
login_name="admin"
password="<password here>"
branch="root"
polfile=$(cat ../001_root-config.yml)
api_get=$(curl -sk --user $login_name:$password https://$master_name/authn/$dap_name/login)
auth=$(curl -sk -H "Content-Type: text/plain" -d "$api_get" -X POST https://$master_name/authn/$dap_name/$login_name/authenticate)
echo "$auth"
auth_token=$(echo -n $auth | base64 | tr -d '\r\n')
echo "$auth_token"
put_policy=$(curl -k -H "Authorization: Token token=\"$auth_token\"" -X PUT -d "$polfile" https://$master_name/policies/$dap_name/policy/$branch)
echo $put_policy > ./output.log

