#!/bin/bash
# Use this script to create a policy exemption for testing purpose.
# Reference: https://azsec.azurewebsites.net/2021/11/15/trigger-an-on-demand-azure-policy-evaluation-scan-at-management-group-level/
# The following script is used to create an exemption for the storage account named jpstoragedata.

date=$(date +%F-%H%M%SD)
policy_exemption_name="storage-exemption-${date}"
policy_exemption_desc="This storage account is approved to allow publicAccess temporarily"
policy_exemption_displayname="Storage account exemption - ${date}"
policy_exemption_category="waiver"
expire_on="2021-12-23T00:00:00"
policy_exemption_metadata=("RequestedBy=ts" "ApprovedBy=azsec" "ApprovedOn=12/21/2021" "TicketRef=123456789")
policy_assignment="/subscriptions/67d6179d-a99d-4ccd-8c56-4d3ff2e13349/providers/Microsoft.Authorization/policyAssignments/2ca44c27185a4776ab0a5016"

# policy definition reference id is only needed for policy initiative
policy_definition_reference_id=""
policy_exemption_scope="/subscriptions/67d6179d-a99d-4ccd-8c56-4d3ff2e13349/resourceGroups/azsec-corporate-rg/providers/Microsoft.Storage/storageAccounts/jpstoragedata"

az policy exemption create --name "${policy_exemption_name}" \
                           --description "${policy_exemption_desc}" \
                           --display-name "${policy_exemption_displayname}" \
                           --exemption-category "${policy_exemption_category}" \
                           --expires-on "${expire_on}" \
                           --metadata "${policy_exemption_metadata[@]}" \
                           --policy-assignment "${policy_assignment}" \
                           --scope "${policy_exemption_scope}"