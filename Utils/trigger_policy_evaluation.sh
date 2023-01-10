#!/bin/bash
# Use this script to trigger on-demand Azure Policy evaluation scan at management group.
# Reference: https://azsec.azurewebsites.net/2021/11/15/trigger-an-on-demand-azure-policy-evaluation-scan-at-management-group-level/
target_management_group="enterprise-group"
query="resourcecontainers | where type == 'microsoft.resources/subscriptions' | mv-expand mgAncestor = properties.managementGroupAncestorsChain | extend state = properties.state | where mgAncestor.name =~ '${target_management_group}' | where state == 'Enabled' | summarize count() by subscriptionId"
root_management_group_id="root-mg-123456"
# Run az grap query to get list of subscriptions under the target management group
# You need resource-graph extension to query Azure Resource Graph.
# Run az extension add --name resource-graph
subscription_ids=$(az graph query -q "${query}" --management-groups "${root_management_group_id}" --query 'data[].subscriptionId' -o tsv)
for subscription_id in ${subscription_ids}; do
  echo "[-] Found subscription Id: ${subscription_id}"
  echo "[-] Set Subscription context for subscription Id: ${subscription_id}"
  az account set -s ${subscription_id}
  if [ $? -eq 0 ]; then
    echo "[-] Set subscription context succesfully"
    echo "[-] Trigger a policy compliance evaluation for subscription Id: ${subscription_id}"
    az policy state trigger-scan --subscription "${subscription_id}" --no-wait
  else
    echo "[!] Can't set subscription context"
    exit 1
  fi
done
