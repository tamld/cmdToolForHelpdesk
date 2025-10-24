#!/bin/bash

# Script to validate that a Markdown file contains the required CARE headings.
# Usage: ./lint_care_spec.sh /path/to/spec.md

SPEC_FILE="$1"
REQUIRED_HEADINGS=("# Context" "# Actions" "# Risks" "# Expectations")
MISSING_COUNT=0

echo "INFO: Validating spec file: $SPEC_FILE"

if [ ! -f "$SPEC_FILE" ]; then
    echo "ERROR: File not found: $SPEC_FILE" >&2
    exit 1
fi

for heading in "${REQUIRED_HEADINGS[@]}"; do
    # Use grep -q to quietly search for the exact heading at the beginning of a line.
    if ! grep -q "^${heading}" "$SPEC_FILE"; then
        echo "ERROR: Missing required section in $SPEC_FILE: '$heading'" >&2
        ((MISSING_COUNT++))
    fi
done

if [ $MISSING_COUNT -gt 0 ]; then
    echo "ERROR: Validation failed. $MISSING_COUNT required section(s) are missing." >&2
    exit 1
else
    echo "SUCCESS: All required CARE sections found in $SPEC_FILE."
    exit 0
fi
