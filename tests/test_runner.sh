#!/usr/bin/env bash
# Generic test runner for Helm chart tests
# Discovers and runs all test_*.sh files in chart directories under tests/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$SCRIPT_DIR"

# Source common functions
source "$TESTS_DIR/lib/common.sh"

# Find all chart test directories
find_chart_test_dirs() {
    find "$TESTS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name ".*" ! -name "lib" | sort
}

# Find all test files in a chart directory
find_chart_tests() {
    local chart_dir="$1"
    find "$chart_dir" -maxdepth 1 -name "test_*.sh" -type f | sort
}

# Run a single test file
run_test_file() {
    local test_file="$1"
    local chart_name="$2"
    local test_name
    test_name=$(basename "$test_file" .sh)
    
    # Make sure test file is executable
    chmod +x "$test_file"
    
    # Run the test with CHART_NAME set
    local test_output
    local test_exit_code
    test_output=$(CHART_NAME="$chart_name" bash "$test_file" 2>&1)
    test_exit_code=$?
    
    if [ $test_exit_code -eq 0 ]; then
        return 0
    else
        echo -e "  ${RED}✗ ${test_name} failed${NC}"
        # Show error output (filter out successful test messages)
        echo "$test_output" | grep -E "(ERROR|FAILED|Assertion failed)" | sed 's/^/    /' || true
        return 1
    fi
}

# Run tests for a specific chart
run_chart_tests() {
    local chart_test_dir="$1"
    local chart_name
    chart_name=$(basename "$chart_test_dir")
    
    # Find all test files in this chart directory
    local test_files
    test_files=$(find_chart_tests "$chart_test_dir")
    
    if [ -z "$test_files" ]; then
        return 0  # Skip directories without test files
    fi
    
    echo -e "${BLUE}→ Testing chart: ${chart_name}${NC}"
    
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    
    # Run each test file
    while IFS= read -r test_file; do
        total_tests=$((total_tests + 1))
        if run_test_file "$test_file" "$chart_name"; then
            passed_tests=$((passed_tests + 1))
        else
            failed_tests=$((failed_tests + 1))
        fi
    done <<< "$test_files"
    
    if [ $failed_tests -gt 0 ]; then
        echo -e "${RED}  ✗ ${chart_name} failed (${failed_tests}/${total_tests} tests)${NC}"
        echo ""
        return 1
    else
        echo -e "${GREEN}  ✓ ${chart_name} passed (${total_tests} tests)${NC}"
        echo ""
        return 0
    fi
}

# Main execution
main() {
    local chart_dirs
    chart_dirs=$(find_chart_test_dirs)
    
    if [ -z "$chart_dirs" ]; then
        echo -e "${YELLOW}No chart test directories found in $TESTS_DIR${NC}"
        exit 0
    fi
    
    echo "Running Helm Chart Tests"
    echo ""
    
    local total_charts=0
    local passed_charts=0
    local failed_charts=0
    
    # Run tests for each chart
    while IFS= read -r chart_dir; do
        if run_chart_tests "$chart_dir"; then
            passed_charts=$((passed_charts + 1))
        else
            failed_charts=$((failed_charts + 1))
        fi
        total_charts=$((total_charts + 1))
    done <<< "$chart_dirs"
    
    # Print final summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [ $failed_charts -gt 0 ]; then
        echo -e "${RED}✗ FAILED${NC} - $failed_charts of $total_charts chart(s) failed"
        exit 1
    else
        echo -e "${GREEN}✓ PASSED${NC} - All $total_charts chart(s) passed"
        exit 0
    fi
}

# Run main if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
