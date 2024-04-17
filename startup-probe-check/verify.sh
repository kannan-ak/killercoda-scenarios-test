#!/bin/bash

# Check if the deployment is running
deployment_status=$(kubectl get deployment nginx-deployment --output=jsonpath='{.status.conditions[?(@.type=="Available")].status}')

if [ "$deployment_status" != "True" ]; then
    echo "Deployment is not in a running state."
    exit 1
fi

# Check if the startup probe is configured
startup_probe=$(kubectl get deployment nginx-deployment --output=jsonpath='{.spec.template.spec.containers[].startupProbe}')

if [ -n "$startup_probe" ]; then
    echo "Startup probe is configured."
    exit 0
else
    echo "Startup probe is not configured."
    exit 2
fi
