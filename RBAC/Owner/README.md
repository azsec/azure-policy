# Azure Policy to ensure Owner role is assigned to a specific group
This is the sample Azure Policy to ensure Owner role is assigned to a specific group. The role definition Id of Owner (`ownerRoleDefId`) is fixed. You must change your group ID (`cloudOwnerGroupId`)

```json
{
  "name": "deny-owner-role-assignment",
  "properties": {
    "displayName": "Ensure Owner role is only assigned to specific group",
    "description": "This policy is used to ensure Owner role is only assigned to specific group",
    "metadata": {
      "category": "IAM"
    },
    "mode": "All",
    "parameters": {
      "ownerRoleDefId": {
        "type": "string",
        "defaultValue": "8e3af657-a8ff-443c-a75c-2fe8c4bcb635",
        "metadata": {
          "description": "Role Definition ID of built-in Owner Role",
          "displayName": "Role Definition ID of built-in Owner Role"
        }
      },
      "cloudOwnerGroupId": {
        "type": "string",
        "defaultValue": "e9a94e3f-8474-464a-bc12-5f5f71e0aedb",
        "metadata": {
          "description": "ID of Cloud Owner group in AAD",
          "displayName": "ID of Cloud Owner group in AAD"
        }
      },
      "effect": {
        "type": "string",
        "metadata": {
          "displayName": "Effect",
          "description": "Effect of this Azure Policy - Audit, Deny or Disabled"
        },
        "allowedValues": ["Audit", "Deny", "Disabled"]
      }
    },
    "policyRule": {
      "if": {
        "anyOf": [
          {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Authorization/roleAssignments"
              },
              {
                "field": "Microsoft.Authorization/roleAssignments/roleDefinitionId",
                "contains": "[parameters('ownerRoleDefId')]"
              },
              {
                "field": "Microsoft.Authorization/roleAssignments/principalId",
                "notEquals": "[parameters('cloudOwnerGroupId')]"
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
  }
}
```
