#!/usr/bin/env bash
set -euo pipefail

ROOT_PROJECT=$(git rev-parse --show-toplevel)
BUILD_DIR="${ROOT_PROJECT}/build"
TOOLS_DIR="${BUILD_DIR}/tools"
CHART_DIR="${ROOT_PROJECT}/charts/adot-exporter-for-eks-on-ec2"
export PATH="${TOOLS_DIR}:${PATH}"

FAILED_V3=()

echo "Chart validation ${CHART_DIR} with Helm v3"
helm template ${CHART_DIR} | kubeconform || FAILED_V3+=("${CHART_DIR}")

if  [[ "${#FAILED_V3[@]}" -eq 0 ]]; then
    echo "All charts passed validation tests!"
    exit 0
else
    echo "Helm v3:"
    for chart in "${FAILED_V3[@]}"; do
        printf "%40s ❌\n" "$chart"
    done
fi

# Source Code from: https://github.com/aws/eks-charts