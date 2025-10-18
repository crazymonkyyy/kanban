#!/bin/bash

# Usage script for kanban tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Kanban Tools"
echo "============"

if [ $# -eq 0 ]; then
    echo "Available tools:"
    echo "  randomtoggle <file.kantban>    - Randomly toggle completion status of items"
    echo "  validate <file.kantban>        - Validate kanban file format and structure"
    echo "  corrupt <file> [rate] [out]    - Randomly corrupt text file with ASCII chars"
    echo ""
    echo "Usage:"
    echo "  ./run.sh randomtoggle TODO.kantban"
    echo "  ./run.sh validate TODO.kantban"
    echo "  ./run.sh corrupt TODO.kantban 10"
    echo "  ./run.sh randomtoggle ../test.kantban"
    exit 1
fi

TOOL="$1"
shift

case "$TOOL" in
    "randomtoggle")
        echo "Running randomtoggle tool..."
        dmd -i -run "tools/randomtoggle.d" "$@"
        ;;
    "validate")
        echo "Running validate tool..."
        dmd -i -run "tools/validate.d" "$@"
        ;;
    "corrupt")
        echo "Running corrupt tool..."
        dmd -i -run "tools/corrupt.d" "$@"
        ;;
    *)
        echo "Unknown tool: $TOOL"
        echo "Available tools: randomtoggle, validate, corrupt"
        exit 1
        ;;
esac
