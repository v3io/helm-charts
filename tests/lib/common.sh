#!/usr/bin/env bash
# Common functions and utilities for chart tests

# Colors for output (use regular variables to avoid readonly conflicts when sourced multiple times)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test framework variables
TEST_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0
TEST_START_TIME=0

# Get the root directory of the repository
get_repo_root() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # Go up from tests/lib to repo root
    echo "$(cd "$script_dir/../.." && pwd)"
}

# Get the chart directory by name
get_chart_dir() {
    chart_name="$1"
    local repo_root
    repo_root=$(get_repo_root)
    echo "$repo_root/stable/$chart_name"
}

# Check if helm is available
check_helm() {
    local helm="${HELM:-helm}"
    if ! command -v "$helm" &> /dev/null; then
        echo -e "${RED}Error: helm command not found. Please install Helm 3.x${NC}" >&2
        exit 1
    fi
    echo "$helm"
}

# Render the chart with given values to output directory
# Returns the path to the output directory
render_chart() {
    local helm="$1"
    local chart_dir="$2"
    shift 2
    local set_args=("$@")
    
    # Create a temporary directory for output
    local output_dir
    output_dir=$(mktemp -d -t helm-test-XXXXXX)
    
    # Render chart to output directory
    local helm_stderr
    local helm_exit_code
    
    if ! helm_stderr=$("$helm" template test-release "$chart_dir" \
        --output-dir "$output_dir" \
        "${set_args[@]}" 2>&1); then
        echo -e "${RED}ERROR: helm template command failed${NC}" >&2
        echo "$helm_stderr" >&2
        rm -rf "$output_dir"
        return 1
    fi
    
    # Return the output directory path
    echo "$output_dir"
}

# Assert that a value equals expected
assert_equal() {
    local actual="$1"
    local expected="$2"
    local message="${3:-}"
    
    if [ "$actual" == "$expected" ]; then
        return 0
    else
        if [ -n "$message" ]; then
            echo -e "${RED}Assertion failed: $message${NC}" >&2
        fi
        echo -e "${RED}  Expected: '$expected'${NC}" >&2
        echo -e "${RED}  Actual: '$actual'${NC}" >&2
        return 1
    fi
}

# Assert that a value is not empty
assert_not_empty() {
    local value="$1"
    local message="${2:-Value should not be empty}"
    
    if [ -z "$value" ]; then
        echo -e "${RED}Assertion failed: $message${NC}" >&2
        return 1
    fi
    return 0
}

# Assert that a pattern exists in output
assert_contains() {
    local output="$1"
    local pattern="$2"
    local message="${3:-Pattern not found}"
    
    if echo "$output" | grep -q "$pattern"; then
        return 0
    else
        echo -e "${RED}Assertion failed: $message${NC}" >&2
        echo -e "${RED}  Pattern: '$pattern'${NC}" >&2
        return 1
    fi
}

# Start a test
test_start() {
    TEST_COUNT=$((TEST_COUNT + 1))
    TEST_START_TIME=$(date +%s)
    echo -e "${YELLOW}[TEST $TEST_COUNT]${NC} $1"
}

# Mark test as passed
test_pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    local duration=0
    if [ $TEST_START_TIME -gt 0 ]; then
        duration=$(($(date +%s) - TEST_START_TIME))
    fi
    echo -e "${GREEN}  ✓ PASSED${NC} (${duration}s)"
    return 0
}

# Mark test as failed
test_fail() {
    FAIL_COUNT=$((FAIL_COUNT + 1))
    local duration=0
    if [ $TEST_START_TIME -gt 0 ]; then
        duration=$(($(date +%s) - TEST_START_TIME))
    fi
    echo -e "${RED}  ✗ FAILED${NC} (${duration}s)"
    return 1
}

# Print test summary
print_test_summary() {
    echo ""
    echo "=========================================="
    echo "Test Summary"
    echo "=========================================="
    echo "Total tests: $TEST_COUNT"
    echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
    if [ $FAIL_COUNT -gt 0 ]; then
        echo -e "${RED}Failed: $FAIL_COUNT${NC}"
        return 1
    else
        echo -e "${GREEN}Failed: $FAIL_COUNT${NC}"
        return 0
    fi
}
