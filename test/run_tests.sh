#!/usr/bin/env bash
set -e

echo "=== Running Convino tests ==="

# Ensure convino binary exists
if [ ! -f "./convino" ]; then
  echo "Error: convino binary not found. Did the build fail?"
  exit 1
fi

TEST_DIR="test/advanced"
LOG_DIR="test/logs"
mkdir -p "$LOG_DIR"

FAILURES=0

for cfg in $(find "$TEST_DIR" -type f -name "rho_config.txt"); do
  TEST_PATH=$(dirname "$cfg")
  PREFIX_NAME=$(basename "$TEST_PATH")
  echo "--- Running test: $PREFIX_NAME ---"

  pushd "$LOG_DIR" > /dev/null

  if ! ../../convino -d ../$PREFIX_NAME/rho_config.txt --prefix Combination > "${PREFIX_NAME}.log" 2>&1; then
    echo "Test $PREFIX_NAME failed! Check $LOG_DIR/${PREFIX_NAME}.log"
    ((FAILURES++))
  fi

  popd > /dev/null
done

if [ $FAILURES -gt 0 ]; then
  echo "$FAILURES test(s) failed."
  exit 1
else
  echo "All tests passed successfully."
fi
