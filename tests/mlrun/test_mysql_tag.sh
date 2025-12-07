#!/usr/bin/env bash
# Test case: MySQL tag selection based on MLRun API image tag
# This test verifies that the MySQL image tag is correctly selected
# based on the MLRun API image tag version.

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# Chart name (derived from test directory name)
CHART_NAME="${CHART_NAME:-$(basename "$SCRIPT_DIR")}"

# Test name
TEST_NAME="MySQL Tag Selection"

# Function to extract MySQL image tag from output directory
extract_mysql_tag() {
    local output_dir="$1"
    
    # Find the db deployment YAML file
    local db_deployment_file
    db_deployment_file=$(find "$output_dir" -name "*db-deployment.yaml" -o -name "*db-deployment.yml" | head -1)
    
    if [ -z "$db_deployment_file" ] || [ ! -f "$db_deployment_file" ]; then
        echo -e "${RED}ERROR: Could not find db deployment file in output directory${NC}" >&2
        return 1
    fi
    
    # Extract MySQL tag from the deployment file
    # Look for the init container with name "init-mysql" and extract the image tag
    if command -v yq &> /dev/null; then
        yq eval '.spec.template.spec.initContainers[] | select(.name == "init-mysql") | .image | split(":")[1]' "$db_deployment_file" 2>/dev/null
    elif command -v jq &> /dev/null && command -v yaml2json &> /dev/null; then
        yaml2json < "$db_deployment_file" | jq -r '.spec.template.spec.initContainers[]? | select(.name == "init-mysql") | .image | split(":")[1]' 2>/dev/null
    else
        # Fallback: use grep/sed
        grep -A 2 "name: init-mysql" "$db_deployment_file" | grep "image:" | sed -E 's/.*image:[[:space:]]*"mysql:([^"]+)".*/\1/' | head -1
    fi
}

# Test case function
run_test() {
    local helm
    helm=$(check_helm)
    
    local chart_dir
    chart_dir=$(get_chart_dir "$CHART_NAME")
    
    # Only show verbose output if not suppressed
    if [ "${SUPPRESS_SUMMARY:-0}" != "1" ]; then
        echo ""
        echo "=========================================="
        echo "$TEST_NAME"
        echo "=========================================="
        echo ""
    fi
    
    # Test 1: MLRun 1.10.0 should yield MySQL 8.0
    test_start "MLRun 1.10.0 -> MySQL 8.0"
    local output_dir
    output_dir=$(render_chart "$helm" "$chart_dir" \
        --set httpDB.dbType=mysql \
        --set api.image.tag="1.10.0" \
        --set db.image.tag="")
    
    if [ $? -ne 0 ] || [ -z "$output_dir" ]; then
        echo -e "  ${RED}Failed to render chart${NC}"
        test_fail
        return
    fi
    
    local mysql_tag
    mysql_tag=$(extract_mysql_tag "$output_dir")
    local extract_exit=$?
    
    # Clean up output directory
    rm -rf "$output_dir"
    
    if [ $extract_exit -ne 0 ] || [ -z "$mysql_tag" ]; then
        echo -e "  ${RED}Could not extract MySQL tag${NC}"
        test_fail
        return
    fi
    
    if assert_equal "$mysql_tag" "8.0" "MySQL tag should be 8.0 for API tag 1.10.0"; then
        test_pass
    else
        test_fail
    fi
    
    # Test 2: MLRun 1.11.0-rc5 should yield MySQL 8.4
    test_start "MLRun 1.11.0-rc5 -> MySQL 8.4"
    output_dir=$(render_chart "$helm" "$chart_dir" \
        --set httpDB.dbType=mysql \
        --set api.image.tag="1.11.0-rc5" \
        --set db.image.tag="")
    
    if [ $? -ne 0 ] || [ -z "$output_dir" ]; then
        echo -e "  ${RED}Failed to render chart${NC}"
        test_fail
        return
    fi
    
    mysql_tag=$(extract_mysql_tag "$output_dir")
    extract_exit=$?
    
    # Clean up output directory
    rm -rf "$output_dir"
    
    if [ $extract_exit -ne 0 ] || [ -z "$mysql_tag" ]; then
        echo -e "  ${RED}Could not extract MySQL tag${NC}"
        test_fail
        return
    fi
    
    if assert_equal "$mysql_tag" "8.4" "MySQL tag should be 8.4 for API tag 1.11.0-rc5"; then
        test_pass
    else
        test_fail
    fi
    
    # Test 3: Explicit MySQL tag should override conditional logic
    test_start "Explicit MySQL tag 9.0 with MLRun 1.10.0 -> MySQL 9.0"
    output_dir=$(render_chart "$helm" "$chart_dir" \
        --set httpDB.dbType=mysql \
        --set api.image.tag="1.10.0" \
        --set db.image.tag="9.0")
    
    if [ $? -ne 0 ] || [ -z "$output_dir" ]; then
        echo -e "  ${RED}Failed to render chart${NC}"
        test_fail
        return
    fi
    
    mysql_tag=$(extract_mysql_tag "$output_dir")
    extract_exit=$?
    
    # Clean up output directory
    rm -rf "$output_dir"
    
    if [ $extract_exit -ne 0 ] || [ -z "$mysql_tag" ]; then
        echo -e "  ${RED}Could not extract MySQL tag${NC}"
        test_fail
        return
    fi
    
    # Even though MLRun 1.10.0 would normally select MySQL 8.0, 
    # the explicit tag "9.0" should be used instead
    if assert_equal "$mysql_tag" "9.0" "MySQL tag should be 9.0 when explicitly set, overriding conditional logic"; then
        test_pass
    else
        test_fail
    fi
    
    # Test 4: Non-semver API tag with appVersion 1.10.0 should yield MySQL 8.0
    test_start "Non-semver API tag 'latest' with appVersion 1.10.0 -> MySQL 8.0"
    output_dir=$(render_chart "$helm" "$chart_dir" \
        --set httpDB.dbType=mysql \
        --set api.image.tag="latest" \
        --set db.image.tag="")
    
    if [ $? -ne 0 ] || [ -z "$output_dir" ]; then
        echo -e "  ${RED}Failed to render chart${NC}"
        test_fail
        return
    fi
    
    mysql_tag=$(extract_mysql_tag "$output_dir")
    extract_exit=$?
    
    # Clean up output directory
    rm -rf "$output_dir"
    
    if [ $extract_exit -ne 0 ] || [ -z "$mysql_tag" ]; then
        echo -e "  ${RED}Could not extract MySQL tag${NC}"
        test_fail
        return
    fi
    
    # Non-semver tag should fallback to appVersion (1.10.0) which should yield MySQL 8.0
    if assert_equal "$mysql_tag" "8.0" "MySQL tag should be 8.0 for non-semver API tag when appVersion is 1.10.0"; then
        test_pass
    else
        test_fail
    fi
    
    # Test 5: Non-semver API tag with appVersion 1.11.0 should yield MySQL 8.4
    test_start "Non-semver API tag 'dev' with appVersion 1.11.0 -> MySQL 8.4"
    
    # Temporarily modify Chart.yaml to set appVersion to 1.11.0
    local chart_yaml="$chart_dir/Chart.yaml"
    local chart_yaml_backup
    chart_yaml_backup=$(mktemp)
    cp "$chart_yaml" "$chart_yaml_backup"
    
    # Update appVersion to 1.11.0
    if sed -i.bak 's/^appVersion:.*/appVersion: 1.11.0/' "$chart_yaml"; then
        output_dir=$(render_chart "$helm" "$chart_dir" \
            --set httpDB.dbType=mysql \
            --set api.image.tag="dev" \
            --set db.image.tag="")
        
        local render_exit=$?
        
        # Restore Chart.yaml
        mv "$chart_yaml_backup" "$chart_yaml"
        rm -f "${chart_yaml}.bak"
        
        if [ $render_exit -ne 0 ] || [ -z "$output_dir" ]; then
            echo -e "  ${RED}Failed to render chart${NC}"
            test_fail
            return
        fi
        
        mysql_tag=$(extract_mysql_tag "$output_dir")
        extract_exit=$?
        
        # Clean up output directory
        rm -rf "$output_dir"
        
        if [ $extract_exit -ne 0 ] || [ -z "$mysql_tag" ]; then
            echo -e "  ${RED}Could not extract MySQL tag${NC}"
            test_fail
            return
        fi
        
        # Non-semver tag should fallback to appVersion (1.11.0) which should yield MySQL 8.4
        if assert_equal "$mysql_tag" "8.4" "MySQL tag should be 8.4 for non-semver API tag when appVersion is 1.11.0"; then
            test_pass
        else
            test_fail
        fi
    else
        # Restore Chart.yaml on error
        mv "$chart_yaml_backup" "$chart_yaml"
        rm -f "${chart_yaml}.bak"
        echo -e "  ${RED}Failed to modify Chart.yaml${NC}"
        test_fail
    fi
    
    # Summary is handled by the test runner, no need to print here
}

# Run the test
run_test
