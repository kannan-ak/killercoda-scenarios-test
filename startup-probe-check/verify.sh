#!/bin/bash

# Function to check deployment status and startup probe configuration
check_deployment_and_probe() {
  deployment_name="$1"

  # Get deployment details in JSON format
  deployment_info=$(kubectl get deployment "$deployment_name" -o json)

  # Check if deployment exists and retrieve exit code
  deployment_exists=$?

  # Exit if deployment doesn't exist
  if [[ $deployment_exists -ne 0 ]]; then
    echo "Error: Deployment '$deployment_name' not found."
    exit 1
  fi

  # Check deployment status using JSONPath
  deployment_status=$(echo "$deployment_info" | jq -r '.status.readyReplicas')

  # Check if deployment has at least 1 ready replica
  if [[ -z "$deployment_status" || "$deployment_status" -eq 0 ]]; then
    echo "Warning: Deployment '$deployment_name' is not running or has 0 ready replicas."
  else
    # Check if startupProbe exists using JSONPath
    startup_probe=$(echo "$deployment_info" | jq -r '.spec.template.spec.containers[0].startupProbe')

    # Check if startupProbe is not null (configured)
    if [[ -n "$startup_probe" ]]; then
      echo "Correct. Deployment '$deployment_name' is running and has a properly configured startup probe."
    else
      echo "Warning: Deployment '$deployment_name' is running but has no startup probe configured."
    fi
  fi
}

# Get deployment name from argument (optional)
deployment_name="${1:-}"

# Check if deployment name is provided
if [[ -z "$deployment_name" ]]; then
  echo "Usage: $0 <deployment_name>"
  exit 1
fi

# Call the check function
check_deployment_and_probe "$deployment_name"
