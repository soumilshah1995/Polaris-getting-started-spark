#!/bin/bash

# Set your Polaris token
PRINCIPAL_TOKEN="principal:root;realm:default-realm"

# Set the Polaris server URL
POLARIS_URL="http://localhost:8181"

# Set the catalog name
CATALOG_NAME="polaris"

# Create the catalog
echo "Creating catalog..."
curl -i -X POST \
  -H "Authorization: Bearer $PRINCIPAL_TOKEN" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  $POLARIS_URL/api/management/v1/catalogs \
  -d '{
    "catalog": {
      "name": "'$CATALOG_NAME'",
      "type": "INTERNAL",
      "readOnly": false,
      "properties": {
        "default-base-location": "file:///tmp/'$CATALOG_NAME'/"
      },
      "storageConfigInfo": {
        "storageType": "FILE",
        "allowedLocations": [
          "file:///tmp"
        ]
      }
    }
  }'

# Create a catalog role
echo "Creating catalog role..."
curl -X POST "$POLARIS_URL/api/management/v1/catalogs/$CATALOG_NAME/catalog-roles" \
-H "Authorization: Bearer $PRINCIPAL_TOKEN" \
-H "Content-Type: application/json" \
-d '{"catalogRole": {"name": "admin_role"}}'

# Grant privileges to the catalog role
echo "Granting privileges to catalog role..."
curl -X PUT "$POLARIS_URL/api/management/v1/catalogs/$CATALOG_NAME/catalog-roles/admin_role/grants" \
-H "Authorization: Bearer $PRINCIPAL_TOKEN" \
-H "Content-Type: application/json" \
-d '{"grant": {"type": "catalog", "privilege": "CATALOG_MANAGE_CONTENT"}}'

# Create a principal role
echo "Creating principal role..."
curl -X POST "$POLARIS_URL/api/management/v1/principal-roles" \
-H "Authorization: Bearer $PRINCIPAL_TOKEN" \
-H "Content-Type: application/json" \
-d '{"principalRole": {"name": "admin_principal_role"}}'

# Assign the catalog role to the principal role
echo "Assigning catalog role to principal role..."
curl -X PUT "$POLARIS_URL/api/management/v1/principal-roles/admin_principal_role/catalog-roles/$CATALOG_NAME" \
-H "Authorization: Bearer $PRINCIPAL_TOKEN" \
-H "Content-Type: application/json" \
-d '{"catalogRole": {"name": "admin_role"}}'

# Assign the principal role to the root principal
echo "Assigning principal role to root..."
curl -X PUT "$POLARIS_URL/api/management/v1/principals/root/principal-roles" \
-H "Authorization: Bearer $PRINCIPAL_TOKEN" \
-H "Content-Type: application/json" \
-d '{"principalRole": {"name": "admin_principal_role"}}'

echo "Setup complete!"

