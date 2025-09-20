#!/usr/bin/env bash
set -euo pipefail

echo "Waiting for VM SSH to be ready..."
sleep 60

if nc -z localhost 2222; then
  echo "✅ VM is up and reachable via SSH"
else
  echo "❌ VM is not reachable via SSH"
  exit 1
fi

